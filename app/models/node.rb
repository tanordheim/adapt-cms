# encoding: utf-8

class Node < ActiveRecord::Base #:nodoc

  # Nodes form a tree structure, provided by the Ancestry gem.
  has_ancestry

  # Nodes are userstamped so that the creator and updater admins are properly
  # registered.
  include Userstamp

  # Nodes belong to a site, and defines a piece of content associated with the
  # site.
  belongs_to :site

  # Nodes can belong to a variant, describing additional meta data for the node.
  belongs_to :variant

  # Nodes can have one or more variant attributes describing the value of an
  # attribute within the node variant.
  has_many :variant_attributes, :dependent => :destroy, :before_add => :add_self_to_variant_attribute, :autosave => true

  # Nodes can have one or more activities, acting as log entries for
  # administrators doing changes to any given node.
  has_many :activities, :as => :source, :dependent => :destroy

  # Nodes are sorted by the acts_as_list gem using, and the sorting is
  # scoped to the ancestry string of the node.
  acts_as_list :scope => '#{ancestry.nil? ? "ancestry IS NULL" : "ancestry = \'#{ancestry}\'"}', :top_of_list => 0
  
  # Validate that the node is associated with a site.
  validates :site, :presence => true

  # Validate that the node has a name set.
  validates :name, :presence => true

  # Validate that the variant assigned to the node is of the correct type
  validate :validate_variant_type

  # Assign a default slug if no slug has been specified.
  before_validation :assign_default_slug

  # Rebuild the uri of this node before saving it.
  before_save :rebuild_uri

  # Rebuild the uri of all descendants after saving this node.
  after_save :rebuild_descendant_uris

  # Before saving the node, flag variant attributes not matching the currently
  # assigned variant blueprint for destruction.
  before_save :flag_stale_variant_attributes_for_destruction

  # The sorted scope sorts the nodes by their position attribute, ascending.
  scope :sorted, order('nodes.position ASC')

  # The by_date scope sorts the nodes by their created at value, descending.
  scope :by_date, order('nodes.created_at DESC')

  # Returns all the page nodes.
  scope :pages, where(:type => 'Page')

  # Returns all the link nodes.
  scope :links, where(:type => 'Link')

  # Returns all the blog nodes.
  scope :blogs, where(:type => 'Blog')

  # Returns all the blog post nodes.
  scope :blog_posts, where(:type => 'BlogPost')

  # Returns all nodes except blog posts.
  scope :without_blog_posts, where(['nodes.type IS NULL OR nodes.type != ?', 'BlogPost'])

  # Returns all nodes that are visible in navigation.
  scope :visible_in_navigation, where(:show_in_navigation => true)

  # Adds the variant attributes to the query.
  scope :with_attributes, includes(:variant_attributes)

  # Adds the variant to the query.
  scope :with_variant, includes(:variant)

  # Nodes are searchable through Sunspot
  searchable do

    # Index the node id.
    integer :id

    # Index the node classification.
    string :classification

    # Index the node name.
    text :name, :default_boost => 5

    # Index some meta data.
    string :uri

    # Index the site and parent node reference
    integer :site_id, :references => Site
    integer :parent_id
    string :parent_uri

    # Index the created at and published on date fields.
    time :published_on
    time :created_at

    # Index the text fields on the node.
    text :text_fields, :default_boost => 2 do
      text_fields = variant.blank? ? [] : variant.text_fields.collect(&:key)
      data.select { |key, value| text_fields.include?(key) }.values
    end

    # Index the string fields on the node.
    text :string_fields do
      string_fields = variant.blank? ? [] : variant.string_fields.collect(&:key)
      data.select { |key, value| string_fields.include?(key) }.values
    end
    
  end

  # Define the class to use for sorting the nodes. This is set to Node to allow
  # subclasses to be sorted with the same scope as this class.
  #
  # @return [ String ] The class to scope acts_as_list sorting by.
  def acts_as_list_class
    Node
  end

  # Returns the uri of the parent node of this node, if any.
  # 
  # @return [ String ] URI of parent node.
  def parent_uri
    is_root? ? nil : parent.uri
  end

  # Returns the children of this node in JSON format. This is recursive and will
  # load the entire tree of descendants.
  #
  # This will not include blog post children.
  #
  # @return [ Array ] An array of hashes containing the child information.
  def children_as_json

    json = []

    # Iterate through children and get the JSON representation of each child.
    children.without_blog_posts.sorted.each do |child|
      json << child.to_simplified_json
    end

    json

  end

  # Returns a simplified JSON structure of this node. This doesn't include any
  # variant attributes, just the basic node data. It also calls
  # +children_as_json+ to include any children of the node in the data
  # structure.
  #
  # @return [ Hash ] A hash representation of the node.
  def to_simplified_json
    {
      :id => id,
      :name => name,
      :published => published,
      :show_in_navigation => show_in_navigation,
      :uri => uri,
      :classification => classification,
      :creator_id => creator_id,
      :updater_id => updater_id,
      :created_at => created_at,
      :updated_at => updated_at,
      :children => children_as_json
    }
  end

  # Returns an array containing the IDs and names of all parents of this node,
  # starting with the top-most parent.
  def parents
    ancestors.all.inject([]) do |parents, node|
      parents << {:id => node.id, :uri => node.uri, :name => node.name, :classification => node.classification}
      parents
    end
  end

  # Returns this nodes classification. This does a transformation on the node
  # class to represent a data export friendly node classification.
  def classification
    (self.type || 'node').underscore
  end

  # Returns the name of the view that should be used for rendering this node.
  # This is a combination of the node type plus the variant associated with the
  # node.
  def view_name
    filename = self.class.name.underscore
    if !self.variant.blank?
      filename += ".#{self.variant.view_suffix}"
    end
    filename
  end

  # Override the variant_id setter to prepare an attribute blueprint for this
  # model when the variant changes.
  def variant_id=(variant_id)
    super
    prepare_variant_attribute_blueprint
  end

  # Override the variant setter to prepare an attribute blueprint for this model
  # when the variant changes.
  def variant=(variant)
    self.variant_id = variant.nil? ? nil : variant.id # prepare_variant_attributes is called in the id setter.
  end

  # Returns the variant attribute data for this node as a hash.
  def data
    variant_attributes.inject({}) do |data, variant_attribute|
      data[variant_attribute.key.to_sym] = variant_attribute.value
      data
    end
  end

  # Set the variant attribute data for this node by passing in a hash. If an
  # attempt is set to define attributes that are not a part of the variant
  # associated with the node, those attributes will not be persisted.
  def data=(data)
    data.each do |key, value|
      variant_attribute = get_or_create_variant_attribute_by_key(key)
      variant_attribute.value = value
    end
  end

  # Return a Liquid representation of this node.
  def to_liquid

    return @to_liquid if defined?(@to_liquid)

    # Prepare some data
    children = self.children.with_attributes.sorted
    ancestors = self.ancestors.with_attributes
    
    # Convert the node to Liquid
    liquid = convert_node_to_liquid(self)

    # Convert all children to Liquid
    liquid['children'] = []
    children.each do |node|
      liquid['children'] << convert_node_to_liquid(node)
    end

    # Convert all children that are visible in the navigation to liquid
    liquid['navigation'] = []
    children.select { |n| n.show_in_navigation? }.each do |node|
      liquid['navigation'] << convert_node_to_liquid(node)
    end

    # Add all ancestors if we have any
    liquid['ancestors'] = []
    ancestors.each do |ancestor|
      liquid['ancestors'] << convert_node_to_liquid(ancestor)
    end

    # Add the parent node if we have one
    unless is_root?
      liquid['parent'] = convert_node_to_liquid(ancestors.last)
    end

    # Add the root parent if we have one
    unless is_root?
      liquid['root_parent'] = convert_node_to_liquid(ancestors.first)
    end

    @to_liquid = liquid
    liquid

  end
  
  private

  # Assign a default slug to this node if no slug has been specified. This
  # generates a string based on the node name.
  def assign_default_slug
    self.slug = generate_slug_from_name if slug.blank?
  end

  # Generate a slug based on the node name.
  #
  # @return [ String ] The generated slug.
  def generate_slug_from_name

    slug = name.blank? ? '' : name.dup
    slug.downcase!                    # Make the slug all lower case.
    slug.strip!                       # Remove leading/trailing whitespace.
    slug.gsub!(/[^a-z0-9\s-_]/, '')   # Remove all non-URL friendly characters.
    slug.gsub!(/\s+/, '_')            # Change all whitespaces to underscores.
    slug.gsub!(/_+/, '_')             # Remove double (or more) underscores.
    slug.gsub!(/_\z/, '')             # Remove trailing underscores.

    slug

  end

  # Rebuild the uri of this node based on the slug and all ancestor slugs.
  def rebuild_uri
    self.uri = uri_for_node(self)
  end

  # Builds a uri for the specfied node, based on the node slug and all ancestor
  # slugs.
  #
  # @return [ String ] Uri for the specified node.
  def uri_for_node(node)
    (node.ancestors.collect(&:slug) + [node.slug]).join('/')
  end

  # Rebuild the uris of all ascendants of this node.
  def rebuild_descendant_uris

    # Skip descendant uri rebuilding unless we actually need to go through with
    # it.
    return unless should_rebuild_descendant_uris?

    children.each do |child|
      child.update_attributes({:uri => uri_for_node(child)})
    end

  end

  # Determines if we need to rebuild descendant uris when persisting this node.
  #
  # We skip descendant uri rebuilding if this is a new record, the uri field
  # hasn't changed, or the node has no children.
  #
  # We also skip descendant uri rebuilding if the ancestry column has changed,
  # since the Ancestry gem will re-save all the descendants to change their
  # ancestry column - which will cause the rebuild_uri callback to be executed
  # on them as well.
  def should_rebuild_descendant_uris?
    if new_record? || !uri_changed? || changed.include?(self.base_class.ancestry_column.to_s) || !has_children?
      false
    else
      true
    end
  end

  # Validates that the variant type assigned to this node, if any, is of the
  # correct type.
  def validate_variant_type
    if !variant.blank?
      Rails.logger.debug("Variant node type: #{variant.node_type}")
      Rails.logger.debug("Classification: #{classification}")
    end
    if !variant.blank? && variant.node_type != classification
      errors.add(:variant_id, 'not a valid variant')
    end
  end

  # Assign an instance of self to a variant attribute added to the list.
  def add_self_to_variant_attribute(variant_attribute)
    variant_attribute.node = self
  end

  # Returns a variant attribute by the key.
  #
  # @return [ VariantAttribute ] Variant attribute matching the specified key.
  def variant_attribute_by_key(key)
    variant_attributes.select { |variant_attribute| variant_attribute.key == key.to_s }.first
  end

  # Returns a variant attribute by the key. If the variant attribute can not be
  # found, a new attribute will be returned with a nil value.
  def get_or_create_variant_attribute_by_key(key)
    variant_attribute = variant_attribute_by_key(key)
    if variant_attribute.nil?
      variant_attribute = variant_attributes.build(:key => key.to_s)
    end
    variant_attribute
  end

  # Prepare the variant attribute blueprint for this node. This is called when
  # the variant changes, and will add variant attributes to the node with a nil
  # value matching the field keys found within the variant.
  def prepare_variant_attribute_blueprint

    return if variant.blank?
    variant.fields.each do |field|

      key = field.key

      # If the node does not have an attribute matching this key, add it.
      attribute = variant_attribute_by_key(key)
      if attribute.nil?
        variant_attributes.build(:key => key)
      end

    end

  end

  # Flag variant attributes not matching the assigned variant blueprint for
  # destruction so they are removed when this node is persisted.
  def flag_stale_variant_attributes_for_destruction

    if variant.blank? || variant.fields.size == 0
      # If this variant has no fields, flag all fields for destruction
      variant_attributes.each(&:mark_for_destruction)
    else

      # Go through each attribute on this node. If any of the attributes aren't
      # found within the field definitions of the variant, flag them for
      # destruction.
      field_keys = variant.fields.collect(&:key)
      variant_attributes.each do |variant_attribute|
        if !field_keys.include?(variant_attribute.key)
          variant_attribute.mark_for_destruction
        end
      end

    end

    true
  end

  # Convert the specified node to Liquid format
  def convert_node_to_liquid(node)

    {
      'id' => node.id,
      'classification' => node.classification,
      'view' => node.view_name,
      'uri' => node.uri,
      'name' => node.name,
      'published' => node.published,
      'show_in_navigation' => node.show_in_navigation,
      'data' => node.data.stringify_keys
    }
  end

end

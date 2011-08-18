# encoding: utf-8

class Variant < ActiveRecord::Base #:nodoc

  # Defines the acceptable node types for a variant.
  NODE_TYPES = %w(blog blog_post link page)

  # Variants are sorted by the acts_as_list gem using, and the sorting is scoped
  # to the site id and node type of the variant.
  acts_as_list :scope => 'site_id = #{site_id} AND node_type = \'#{node_type}\'', :top_of_list => 0

  # Variants belongs to a site, and describes a set of custom attributes for any
  # given node type.
  belongs_to :site

  # Variants have many variant fields, describing the fields available within
  # the variant.
  has_many :fields, :class_name => 'VariantField', :dependent => :destroy, :before_add => :assign_self_to_variant_field
  has_many :check_box_fields, :class_name => 'VariantFields::CheckBoxField', :before_add => :assign_self_to_variant_field
  has_many :radio_fields, :class_name => 'VariantFields::RadioField', :before_add => :assign_self_to_variant_field
  has_many :resource_reference_fields, :class_name => 'VariantFields::ResourceReferenceField', :before_add => :assign_self_to_variant_field
  has_many :form_reference_fields, :class_name => 'VariantFields::FormReferenceField', :before_add => :assign_self_to_variant_field
  has_many :select_fields, :class_name => 'VariantFields::SelectField', :before_add => :assign_self_to_variant_field
  has_many :string_fields, :class_name => 'VariantFields::StringField', :before_add => :assign_self_to_variant_field
  has_many :text_fields, :class_name => 'VariantFields::TextField', :before_add => :assign_self_to_variant_field
  
  # Validate that the variant is associated with a site.
  validates :site, :presence => true

  # Validate that the variant has a node type set.
  validates :node_type, :presence => true, :inclusion => { :in => NODE_TYPES }

  # Validate that the variant has a name set, and that the name is unique for
  # the site and node type, regardless of case.
  validates :name, :presence => true, :uniqueness => { :scope => [:site_id, :node_type], :case_sensitive => false }

  # By default, variants are sorted by the position column, ascending.
  default_scope order('variants.position ASC')

  # Returns all variants for the blog node type.
  scope :blog_variants, where(:node_type => 'blog')

  # Returns all variants for the blog post node type.
  scope :blog_post_variants, where(:node_type => 'blog_post')

  # Returns all variants for the link node type.
  scope :link_variants, where(:node_type => 'link')

  # Returns all variants for the page node type.
  scope :page_variants, where(:node_type => 'page')

  # Returns the suffix that should be used on view templates on nodes that use
  # this variant.
  def view_suffix
    self.name.downcase.gsub(/\s+/, '_')
  end

  private

  # Add an instance of self to a variant field added to the list.
  def assign_self_to_variant_field(variant_field)
    variant_field.variant = self
  end

end

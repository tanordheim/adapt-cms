# encoding: utf-8

class Design < ActiveRecord::Base #:nodoc

  # Designs belong to sites, and acts as a set of design resources used to
  # decorate the site content.
  belongs_to :site

  # Validate that the design is associated with a site.
  validates :site, :presence => true

  # Validate that the design has a name set, and that the name is unique for
  # this site, regardless of case.
  validates :name, :presence => true, :uniqueness => { :scope => :site_id, :case_sensitive => false }

  # Validaite that the design has some content set.
  validates :markup, :presence => true

  # Designs can have several include templates that provide reusable templates
  # for inclusion in designs or view templates.
  has_many :include_templates, :dependent => :destroy

  # Designs can have several view templates that provides templates for
  # rendering specific types of content.
  has_many :view_templates, :dependent => :destroy

  # Designs can have several resources, defining assets used in the the design.
  has_many :resources, :class_name => 'DesignResource', :dependent => :destroy

  # Designs can have several stylesheets, defining the look of the design.
  has_many :stylesheets, :dependent => :destroy

  # Designs can have several javascripts, defining the client side behaviour of
  # the design.
  has_many :javascripts, :dependent => :destroy

  # Before saving the design, ensure that its flagged as the default design if
  # there are no other designs present for this site.
  before_save :set_default_if_first_design

  # Before saving the design, make sure the current default design is flagged as
  # non-default if this design is the new default design.
  before_save :unset_old_default_if_this_is_default

  # By default, designs are sorted by name, ascending. The default design is
  # always put first, regardless of alphabetical order.
  default_scope order('designs.default DESC').order('LOWER(designs.name) ASC')

  # Returns the designs flagged as default. Should only return one design within
  # an ActiveRecord::Relation collection.
  scope :default_designs, where(:default => true)

  # Returns the view template to use for the specified node.
  def view_template_for_node(node)

    filename = node.class.name.underscore
    if !node.variant.blank?
      filename += ".#{node.variant.name.underscore}"
    end

    view_templates.select { |t| t.filename == filename }.first

  end

  private

  # Set this design as the default design if its the first design created for
  # the site.
  def set_default_if_first_design
    self.default = true if Design.where(:site_id => site.id).count == 0
    true
  end

  # Unset the default flag on the old default design if this design is the new
  # default design.
  def unset_old_default_if_this_is_default
    if self.default?
      query = Design.where(:site_id => site.id).where(:default => true)
      query = query.where(['designs.id != ?', id]) unless new_record?
      query.update_all(['"default" = ?', false])
    end
    true
  end

end

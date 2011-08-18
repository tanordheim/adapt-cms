# encoding: utf-8

class VariantField < ActiveRecord::Base #:nodoc

  # The accepted key format for model variant fields.
  KEY_FORMAT = /^[a-z][a-z0-9_-]{3,}$/
  
  # Variant fields belong to variants, and describe a field within the variant
  # field collection.
  belongs_to :variant

  # Variant fields are sorted by the acts_as_list gem, and the sorting is scoped
  # to the parent variant of the field.
  acts_as_list :scope => :variant, :top_of_list => 0
  
  # Validate that the variant field is associated with a variant.
  validates :variant, :presence => true

  # Validate that the variant field has a key set, that the key is unique
  # within the variant, and that it follows the correct format.
  validates :key, :presence => true, :uniqueness => { :scope => :variant_id }, :format => { :with => KEY_FORMAT }

  # Validate that the variant field has a name set.
  validates :name, :presence => true

  # By default, variant fields are sorted by the position column, ascending.
  default_scope order('variant_fields.position ASC')
  
  # Returns this variant fields classification. This does a transformation on
  # the variant field class to represent a data export friendly variant field
  # type.
  def classification
    self.class.name.demodulize.underscore.gsub(/^variant_/, '')
  end

end

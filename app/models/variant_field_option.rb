# encoding: utf-8

class VariantFieldOption < ActiveRecord::Base #:nodoc

  # Variant field options belongs to variant fields, and describes an option for
  # a variant field that supports this.
  belongs_to :field, :class_name => 'VariantField', :foreign_key => 'variant_field_id'

  # Variant field options are sorted by the acts_as_list gem using, and the
  # sorting is scoped to the parent variant field of the variant field option.
  acts_as_list :scope => :variant_field_id, :top_of_list => 0

  # Validate that the variant field option has a field associated with it.
  validates :field, :presence => true
  
  # Validate that the variant field option has a value set, and that the value
  # is unique within the field, regardless of case.
  validates :value, :presence => true, :uniqueness => { :scope => :variant_field_id, :case_sensitive => false }

  # By default, variant fields options are sorted by the position column,
  # ascending.
  default_scope order('variant_field_options.position ASC')
  
end

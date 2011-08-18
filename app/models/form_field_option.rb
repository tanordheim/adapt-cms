# encoding: utf-8

class FormFieldOption < ActiveRecord::Base #:nodoc

  # Form field options belongs to form fields, and describes an option for a
  # form field that supports this.
  belongs_to :field, :class_name => 'FormField', :foreign_key => 'form_field_id'

  # Form field options are sorted by the acts_as_list gem using, and the sorting
  # is scoped to the parent form field of the form field option.
  acts_as_list :scope => :form_field_id, :top_of_list => 0

  # Validate that the form field option has a field associated with it.
  validates :field, :presence => true
  
  # Validate that the form field option has a value set, and that the value is
  # unique within the field, regardless of case.
  validates :value, :presence => true, :uniqueness => { :scope => :form_field_id, :case_sensitive => false }

  # By default, form fields options are sorted by the position column,
  # ascending.
  default_scope order('form_field_options.position ASC')

end

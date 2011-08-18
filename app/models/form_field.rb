# encoding: utf-8

class FormField < ActiveRecord::Base #:nodoc

  # Form fields belong to forms and define the user input fields available
  # within the form.
  belongs_to :form

  # Form fields are sorted by the acts_as_list gem, and the sorting is scoped to
  # the parent form of the field.
  acts_as_list :scope => :form, :top_of_list => 0
  
  # Validate that the form field has a form associated with it.
  validates :form, :presence => true
  
  # Validate that the form has a name set, and that the name is unique within
  # the form, regardless of case.
  validates :name, :presence => true, :uniqueness => { :scope => :form_id, :case_sensitive => false }

  # By default, form fields are sorted by the position column, ascending.
  default_scope order('form_fields.position ASC')

  # Returns this form fields classification. This does a transformation on the
  # form field class to represent a data export friendly form field
  # classification.
  def classification
    self.class.name.demodulize.underscore.gsub(/^form_/, '')
  end

  # Define the class to use for sorting the form fields. This is set to
  # FormField to allow subclasses to be sorted with the same scope as this
  # class.
  #
  # @return [ String ] The class to scope acts_as_list sorting by.
  def acts_as_list_class
    FormField
  end

  # Return a Liquid representation of this form field
  def to_liquid
    {
      'id' => self.id,
      'name' => self.name,
      'default_text' => self.default_text,
      'classification' => self.classification
    }
  end

end

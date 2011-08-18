# encoding: utf-8

class Form < ActiveRecord::Base #:nodoc

  # Forms belong to sites, and defines user input forms that can be associated
  # with the site content to aquire user input.
  belongs_to :site

  # Forms have many form fields, describing the fields available within the
  # form.
  has_many :fields, :class_name => 'FormField', :dependent => :destroy, :before_add => :assign_self_to_form_field
  has_many :text_fields, :class_name => 'FormFields::TextField', :before_add => :assign_self_to_form_field
  has_many :string_fields, :class_name => 'FormFields::StringField', :before_add => :assign_self_to_form_field
  has_many :check_box_fields, :class_name => 'FormFields::CheckBoxField', :before_add => :assign_self_to_form_field
  has_many :select_fields, :class_name => 'FormFields::SelectField', :before_add => :assign_self_to_form_field

  # Validate that the form is associated with a site.
  validates :site, :presence => true

  # Validate that the form has a name set.
  validates :name, :presence => true

  # Validate that the form has a submit text set.
  validates :submit_text, :presence => true

  # Validate that the form has a success url set.
  validates :success_url, :presence => true

  # By default, forms are sorted by their name, ascending.
  default_scope order('LOWER(forms.name) ASC')

  # This scope includes the form field in the query when loading a form.
  scope :with_fields, includes(:fields)

  # Returns this forms variant. This does a transformation on the form class to
  # represent an data export friendly form type.
  def variant
    self.class.name.underscore
  end

  # Return a Liquid representation of this form
  def to_liquid
    {
      'id' => self.id,
      'name' => self.name,
      'uri' => "/forms/#{self.id}",
      'submit_text' => self.submit_text,
      'fields' => self.fields.collect(&:to_liquid)
    }
  end

  private

  # Assign an instance of self to a form field added to the list.
  def assign_self_to_form_field(form_field)
    form_field.form = self
  end

end

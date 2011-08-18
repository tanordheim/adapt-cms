# encoding: utf-8

# Adds support for option fields on a form field model.
#
# This adds an association to the model called +form_field_options+, plus two
# helper methods +options+ and +options=+ that returns and sets the field
# options as an array of strings.
module FormFields::OptionSupport

  extend ActiveSupport::Concern

  included do

    # Fields can have options describing each possible user choice for the field.
    has_many :form_field_options, :foreign_key => 'form_field_id', :dependent => :destroy, :before_add => :assign_self_to_form_field_option, :autosave => true

  end

  module InstanceMethods

    # Returns an array of options for this field.
    #
    # @return [ Array ] Array of String values.
    def options
      @options ||= form_field_options.collect(&:value)
    end

    # Sets the array of options for this field.
    def options=(options)

      # Flag any old options as destroyed
      form_field_options.reverse.each do |old_option|
        remove_option(old_option)
      end

      # Add the new options to the collection
      options.each do |option|
        form_field_options.build(:value => option)
      end

      # Set the new options array
      @options = options

    end

    # Return a Liquid representation of this form
    def to_liquid
      liquid = super
      liquid['options'] = self.options
      liquid
    end

    private

    # Assigns a reference of self to a form field option added to the form field
    # options collection.
    def assign_self_to_form_field_option(form_field_option)
      form_field_option.field = self
    end

    # Removes an option from the field option collection, and flags it for
    # deletion when the form field record is saved.
    def remove_option(form_field_option)
      form_field_option.mark_for_destruction
    end
    
  end

end

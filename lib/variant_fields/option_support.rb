# encoding: utf-8

# Adds support for option fields on a variant field model.
#
# This adds an association to the model called +variant_field_options+, plus two
# helper methods +options+ and +options=+ that returns and sets the field
# options as an array of strings.
module VariantFields::OptionSupport

  extend ActiveSupport::Concern

  included do

    # Fields can have options describing each possible user choice for the field.
    has_many :variant_field_options, :foreign_key => 'variant_field_id', :dependent => :destroy, :before_add => :assign_self_to_variant_field_option, :autosave => true

  end

  module InstanceMethods

    # Returns an array of options for this field.
    #
    # @return [ Array ] Array of String values.
    def options
      @options ||= variant_field_options.collect(&:value)
    end

    # Sets the array of options for this field.
    def options=(options)

      # Flag any old options as destroyed
      variant_field_options.reverse.each do |old_option|
        remove_option(old_option)
      end

      # Add the new options to the collection
      options.each do |option|
        variant_field_options.build(:value => option)
      end

      # Set the new options array
      @options = options

    end

    private

    # Assigns a reference of self to a variant field option added to the variant
    # field options collection.
    def assign_self_to_variant_field_option(variant_field_option)
      variant_field_option.field = self
    end

    # Removes an option from the field option collection, and flags it for
    # deletion when the variant field record is saved.
    def remove_option(variant_field_option)
      variant_field_option.mark_for_destruction
    end
    
  end

end

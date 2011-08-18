# encoding: utf-8

class Api::Version1::VariantFields::CheckBoxFieldsController < Api::Version1::VariantFieldsController #:nodoc

  private

  # Define the collection name to use for loading check box fields off the
  # parent variant.
  #
  # @return [ String ] Name of the check box variant fields collection.
  def collection_name
    'check_box_fields'
  end
  
end

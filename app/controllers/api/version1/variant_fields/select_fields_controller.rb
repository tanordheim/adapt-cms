# encoding: utf-8

class Api::Version1::VariantFields::SelectFieldsController < Api::Version1::VariantFieldsController #:nodoc

  private

  # Define the collection name to use for loading select fields off the parent
  # variant.
  #
  # @return [ String ] Name of the select variant fields collection.
  def collection_name
    'select_fields'
  end
  
end

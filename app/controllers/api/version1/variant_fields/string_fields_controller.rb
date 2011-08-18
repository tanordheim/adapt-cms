# encoding: utf-8

class Api::Version1::VariantFields::StringFieldsController < Api::Version1::VariantFieldsController #:nodoc

  private

  # Define the collection name to use for loading string fields off the
  # parent variant.
  #
  # @return [ String ] Name of the string variant fields collection.
  def collection_name
    'string_fields'
  end
  
end

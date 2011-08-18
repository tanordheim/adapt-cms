# encoding: utf-8

class Api::Version1::VariantFields::TextFieldsController < Api::Version1::VariantFieldsController #:nodoc

  private

  # Define the collection name to use for loading text fields off the parent
  # variant.
  #
  # @return [ String ] Name of the text variant fields collection.
  def collection_name
    'text_fields'
  end
  
end

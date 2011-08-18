# encoding: utf-8

class Api::Version1::VariantFields::ResourceReferenceFieldsController < Api::Version1::VariantFieldsController #:nodoc

  private

  # Define the collection name to use for loading resource reference fields off
  # the parent variant.
  #
  # @return [ String ] Name of the resource reference variant fields collection.
  def collection_name
    'resource_reference_fields'
  end
  
end

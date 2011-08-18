# encoding: utf-8

class Api::Version1::VariantFields::FormReferenceFieldsController < Api::Version1::VariantFieldsController

  private

  # Define the collection name to use for loading form reference fields off the
  # parent variant.
  #
  # @return [ String ] Name of the form reference variant fields collection.
  def collection_name
    'form_reference_fields'
  end
  
end

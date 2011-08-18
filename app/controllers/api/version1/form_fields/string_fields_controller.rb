# encoding: utf-8

class Api::Version1::FormFields::StringFieldsController < Api::Version1::FormFieldsController #:nodoc

  private

  # Define the collection name to use for loading string fields off the parent
  # form.
  #
  # @return [ String ] Name of the string form fields collection.
  def collection_name
    'string_fields'
  end
  
end

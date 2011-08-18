# encoding: utf-8

class Api::Version1::FormFields::SelectFieldsController < Api::Version1::FormFieldsController #:nodoc

  private

  # Define the collection name to use for loading select fields off the parent
  # form.
  #
  # @return [ String ] Name of the select form fields collection.
  def collection_name
    'select_fields'
  end
  
end

# encoding: utf-8

class Api::Version1::FormFields::TextFieldsController < Api::Version1::FormFieldsController #:nodoc

  private

  # Define the collection name to use for loading text fields off the parent
  # form.
  #
  # @return [ String ] Name of the text form fields collection.
  def collection_name
    'text_fields'
  end
  
end

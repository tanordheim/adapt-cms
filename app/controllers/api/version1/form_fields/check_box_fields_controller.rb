# encoding: utf-8

class Api::Version1::FormFields::CheckBoxFieldsController < Api::Version1::FormFieldsController #:nodoc

  private

  # Define the collection name to use for loading check box fields off the
  # parent form.
  #
  # @return [ String ] Name of the check box form fields collection.
  def collection_name
    'check_box_fields'
  end

end

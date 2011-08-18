# encoding: utf-8

class Api::Version1::EmailFormsController < Api::Version1::FormsController #:nodoc

  private

  # Override the collection serialization options from the forms controller, and
  # remove the email_address field from the ignored field list.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    options = super
    options[:except].delete(:email_address)
    options
  end

  # Override the object serialization options from the forms controller, and
  # remove the email_address field from the ignored field list.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    options = super
    options[:except].delete(:email_address)
    options
  end

end

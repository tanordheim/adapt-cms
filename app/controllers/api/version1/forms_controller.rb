# encoding: utf-8

class Api::Version1::FormsController < Api::Version1::ApiController #:nodoc

  private

  # Returns the serialization options to use for form collections. This filters
  # out the site_id and email_address attribute, since the email_address
  # attribute isn't used on forms, only email forms.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id, :email_address, :type], :methods => :variant}
  end
  
  # Returns the serialization options to use for form objects. This filters out
  # the site_id attribute, since the email_address attribute isn't used on
  # forms, only email forms.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:site_id, :email_address, :type], :methods => :variant}
  end
  
end

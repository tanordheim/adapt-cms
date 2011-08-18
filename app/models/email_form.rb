# encoding: utf-8

class EmailForm < Form #:nodoc

  # Validate that the form has an email address set.
  validates :email_address, :presence => true

end

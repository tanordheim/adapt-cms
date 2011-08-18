# encoding: utf-8

class Javascript < ActiveRecord::Base #:nodoc

  FILENAME_FORMAT = /^[a-zA-Z0-9\.\-_]+$/
  PROCESSORS = %w(plain)
  
  # Javascripts belong to designs and help define the client side behaviour of
  # the design.
  belongs_to :design

  # Validate that the javascript is associated with a design.
  validates :design, :presence => true
  
  # Validate that the javascript has a processor defined, and that its a valid
  # processor value.
  validates :processor, :presence => true, :inclusion => { :in => PROCESSORS }
  
  # Validate that the javascript has a filename set, that the filename is unique
  # within the design and that it has a valid format.
  validates :filename, :presence => true, :uniqueness => { :scope => :design_id, :case_sensitive => false }, :format => { :with => FILENAME_FORMAT }

  # Validate that thestylesheet has the data set.
  validates :data, :presence => true
  
  # By default, javascripts are sorted by the filename, ascending.
  default_scope order('LOWER(javascripts.filename) ASC')
  
end

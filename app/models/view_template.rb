# encoding: utf-8

class ViewTemplate < ActiveRecord::Base #:nodoc

  FILENAME_FORMAT = /^[a-z0-9\.\-_]+$/

  # View templates belong to designs, and define the layout of specific types of
  # content.
  belongs_to :design

  # Validate that the view template is associated with a design.
  validates :design, :presence => true

  # Validate that the view template has a filename set and that it is of a
  # correct format.
  validates :filename, :presence => true, :uniqueness => { :scope => :design_id, :case_sensitive => false }, :format => { :with => FILENAME_FORMAT }

  # Validate that the view template has markup defined.
  validates :markup, :presence => true

  # By default, view templates are sorted by filename, ascending.
  default_scope order('LOWER(view_templates.filename) ASC')
  
end

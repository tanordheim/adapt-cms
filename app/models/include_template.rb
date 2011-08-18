# encoding: utf-8

class IncludeTemplate < ActiveRecord::Base #:nodoc

  FILENAME_FORMAT = /^[a-z0-9\.\-_]+$/

  # Include templates belong to designs, and define small snipplets of markup
  # that can be reused within view templates.
  belongs_to :design

  # Validate that the include template is associated with a design.
  validates :design, :presence => true

  # Validate that the include template has a filename set and that it is of a
  # correct format.
  validates :filename, :presence => true, :uniqueness => { :scope => :design_id, :case_sensitive => false }, :format => { :with => FILENAME_FORMAT }

  # Validate that the include template has markup defined.
  validates :markup, :presence => true

  # By default, include templates are sorted by filename, ascending.
  default_scope order('LOWER(include_templates.filename) ASC')

end

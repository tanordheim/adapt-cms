# encoding: utf-8

class VariantAttribute < ActiveRecord::Base #:nodoc

  # The accepted key format for variant attribute keys.
  KEY_FORMAT = /^[a-z][a-z0-9_-]{3,}$/

  # Variant attributes belong to nodes, and describes an attribute value within
  # the node variant.
  belongs_to :node

  # Validate that the variant attribute is associated with a node.
  validates :node, :presence => true

  # Validate that the variant attribute has a key set, that the key is unique
  # within this node, and that the key is in the correct format.
  validates :key, :presence => true, :uniqueness => { :scope => :node_id, :case_sensitive => false }, :format => { :with => KEY_FORMAT }
  
end

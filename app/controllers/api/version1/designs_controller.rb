# encoding: utf-8

class Api::Version1::DesignsController < Api::Version1::ApiController #:nodoc

  # Returns the serialization options to use for design collections. This
  # filters out the site_id attribute.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id]}
  end
  
  # Returns the serialization options to use for design objects. This filters
  # out the site_id attribute.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:site_id]}
  end
  
end

# encoding: utf-8

class Api::Version1::ResourcesController < Api::Version1::ApiController #:nodoc

  # Returns the serialization options to use for resource collections. This
  # filters out the site_id and file attributes. It also includes the value of
  # the url method.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id, :file], :methods => :url}
  end
  
  # Returns the serialization options to use for resource objects. This filters
  # out the site_id and file attributes. It also includes the value of the url
  # method.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:site_id, :file], :methods => :url}
  end
  
end

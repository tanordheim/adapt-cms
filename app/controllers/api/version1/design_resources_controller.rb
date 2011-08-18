# encoding: utf-8

class Api::Version1::DesignResourcesController < Api::Version1::ApiController #:nodoc

  private

  # Define the collection name to use for loading design resources of the parent
  # design.
  #
  # @return [ String ] Name of the design resources collection.
  def collection_name
    'resources'
  end
  
  # Use the overlaying design as the parent for all data in this controller.
  #
  # @return [ Design ] The parent design.
  def parent
    current_site.designs.find(params[:design_id])
  end

  # Returns the serialization options to use for design resource collections.
  # This filters out the design_id and file attributes. It also includes the
  # value of the url method.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:design_id, :file], :methods => :url}
  end
  
  # Returns the serialization options to use for design resource objects. This
  # filters out the design_id and file attributes. It also includes the value of
  # the url method.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:design_id, :file], :methods => :url}
  end
  
end

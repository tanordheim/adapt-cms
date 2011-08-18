# encoding: utf-8

class Api::Version1::IncludeTemplatesController < Api::Version1::ApiController #:nodoc

  private

  # Use the overlaying design as the parent for all data in this controller.
  #
  # @return [ Design ] The parent design.
  def parent
    current_site.designs.find(params[:design_id])
  end

  # Returns the serialization options to use for include template collections.
  # This filters out the design_id attribute.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:design_id]}
  end
  
  # Returns the serialization options to use for include template objects. This
  # filters out the design_id attribute.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:design_id]}
  end
  
end

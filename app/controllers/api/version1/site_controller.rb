class Api::Version1::SiteController < Api::Version1::ApiController

  private

  # Returns the serialization options to use for site objects. This filters out
  # the created_at, updated_at and maintenance mode columns.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:created_at, :updated_at, :maintenance_mode]}
  end
  
  # Load the resource for this request. In the Site controller, this returns the
  # currently loaded site.
  #
  # @return [ Site ] The currently loaded site.
  def load_resource
    current_site
  end

end

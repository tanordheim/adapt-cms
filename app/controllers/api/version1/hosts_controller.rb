# encoding: utf-8

class Api::Version1::HostsController < Api::Version1::ApiController #:nodoc

  private

  # Returns the serialization options to use for site host objects. This filters out
  # the site_id column.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:site_id]}
  end

  # Returns the serialization options to use for site hosts collections. This
  # filters out the site_id column.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id]}
  end
  
  # Load the collection for this controller from the database. In the Hosts
  # controller, we load all the hosts registered to the current site.
  #
  # @returns [ Array ] An array of SiteHost objects.
  def load_collection
    current_site.hosts
  end
  
end

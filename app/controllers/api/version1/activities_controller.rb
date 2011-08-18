# encoding: utf-8

class Api::Version1::ActivitiesController < Api::Version1::ApiController #:nodoc

  # Returns the serialization options to use for activity collections. This
  # filters out the site_id and author_id attributes, and includes the value of
  # the author_name and author_email methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id, :author_id], :methods => [:author_name, :author_email]}
  end

  private

  # Return a list of associations we should preload for activities.
  #
  # @returns [ Array ] An array of association names to preload for activities.
  def eager_load_associations
    [:author]
  end
  
end

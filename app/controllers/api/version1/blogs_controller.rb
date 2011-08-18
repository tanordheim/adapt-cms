# encoding: utf-8

class Api::Version1::BlogsController < Api::Version1::ApiController #:nodoc

  private

  # Load the collection of blogs from the database. This applies the sorted
  # scope to the result to get the blogs sorted by their position in the tree.
  #
  # @returns [ Array ] An array of Blog objects.
  def load_collection
    current_site.blogs
  end

  # Returns the serialization options to use for blogs collections. This filters
  # out the site_id, position, ancestry, href and published_on attributes. It
  # also includes the value of the parents and data methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id, :position, :ancestry, :href, :published_on], :methods => [:parents, :data]}
  end
  
  # Returns the serialization options to use for blogs objects. This filters out
  # the site_id, position, ancestry, href and published_on attributes. It also
  # includes the value of the parents and data methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:site_id, :position, :ancestry, :href, :published_on], :methods => [:parents, :data]}
  end
  
end

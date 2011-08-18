# encoding: utf-8

class Api::Version1::BlogPostsController < Api::Version1::ApiController #:nodoc

  private

  # Use the overlaying blog as the parent for all data in this controller.
  #
  # @return [ Blog ] The parent blog.
  def parent
    current_site.blogs.find(params[:parent_id])
  end
  
  # Load the collection of blog post from the database. This applies the sorted
  # scope to the result to get the blog post sorted by their position in the
  # tree.
  #
  # @returns [ Array ] An array of BlogPost objects.
  def load_collection
    parent.posts
  end

  # Loads a blog post from the database.
  #
  # @return [ BlogPost ] The loaded blog post.
  def find_resource
    parent.posts.find(params[:id])
  end

  # Returns the serialization options to use for blog post collections. This
  # filters out the site_id, position, ancestry and href attributes. It also
  # includes the value of the parents and data methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:site_id, :position, :ancestry, :href], :methods => [:parents, :data]}
  end
  
  # Returns the serialization options to use for blog post objects. This filters
  # out the site_id, position, ancestry and href attributes. It also includes
  # the value of the parents and data methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:site_id, :position, :ancestry, :href], :methods => [:parents, :data]}
  end
  
end

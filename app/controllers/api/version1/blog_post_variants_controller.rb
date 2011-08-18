# encoding: utf-8

class Api::Version1::BlogPostVariantsController < Api::Version1::VariantsController #:nodoc

  private

  # Load the collection of blog post variants from the database.
  #
  # @returns [ Array ] An array of Variant objects.
  def load_collection
    current_site.variants.blog_post_variants
  end
  
end

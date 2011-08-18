# encoding: utf-8

class Api::Version1::BlogVariantsController < Api::Version1::VariantsController #:nodoc

  private

  # Load the collection of blog variants from the database.
  #
  # @returns [ Array ] An array of Variant objects.
  def load_collection
    current_site.variants.blog_variants
  end
  
end

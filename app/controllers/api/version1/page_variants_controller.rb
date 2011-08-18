# encoding: utf-8

class Api::Version1::PageVariantsController < Api::Version1::VariantsController #:nodoc

  private

  # Load the collection of page variants from the database.
  #
  # @returns [ Array ] An array of Variant objects.
  def load_collection
    current_site.variants.page_variants
  end
  
end

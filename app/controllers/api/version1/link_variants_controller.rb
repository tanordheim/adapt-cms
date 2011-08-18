# encoding: utf-8

class Api::Version1::LinkVariantsController < Api::Version1::VariantsController #:nodoc

  private

  # Load the collection of link variants from the database.
  #
  # @returns [ Array ] An array of Variant objects.
  def load_collection
    current_site.variants.link_variants
  end
  
end

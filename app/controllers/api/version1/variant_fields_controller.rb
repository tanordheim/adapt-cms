# encoding: utf-8

class Api::Version1::VariantFieldsController < Api::Version1::ApiController #:nodoc

  private

  # Use the overlaying variant as the parent for all data in this controller.
  #
  # @return [ Variant ] The parent variant.
  def parent
    current_site.variants.find(params[:variant_id])
  end

  # Define the collection name to use for loading fields off the parent form.
  #
  # @return [ String ] Name of the form fields collection.
  def collection_name
    'fields'
  end

  # Returns the serialization options to use for variant field collections. This
  # filters out the variant_id, type and position attributes. It also includes
  # the value of the classification method and an array containing the options
  # for the field.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {:except => [:variant_id, :type, :position], :methods => [:classification, :options]}
  end
  
  # Returns the serialization options to use for variant field objects. This
  # filters out the variant_id, type and position attributes. It also includes
  # the value of the classification method and an array containing the options
  # for the field.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [:variant_id, :type, :position], :methods => [:classification, :options]}
  end
  
end

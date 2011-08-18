# encoding: utf-8

class Api::Version1::VariantsController < Api::Version1::ApiController #:nodoc

  private

  # Returns the serialization options to use for variant collections. This
  # filters out the site_id, node_type and position attributes. It also includes
  # the fields associated with the variant, excluding the variant_id and
  # position attributes, and including the classification and options methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {
      :except => [:site_id, :node_type, :position],
      :include => {
        :fields => {
          :except => [:variant_id, :position],
          :methods => [:classification, :options]
        }
      }
    }
  end
  
  # Returns the serialization options to use for variant objects. This filters
  # out the site_id, node_type and position attributes. It also includes the
  # fields associated with the variant, excluding the variant_id and position
  # attributes, and including the classification and options methods.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {
      :except => [:site_id, :node_type, :position],
      :include => {
        :fields => {
          :except => [:variant_id, :position],
          :methods => [:classification,:options]
        }
      }
    }
  end
  
end

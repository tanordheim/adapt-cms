# encoding: utf-8

class Api::Version1::NodesController < Api::Version1::ApiController #:nodoc

  # Node index action. Returns the full node hierarcy in JSON format.
  def index
    respond_with(collection.roots.sorted) do |format|
      format.json { render :json => collection.roots.sorted.collect(&:to_simplified_json).to_json }
    end
  end

  # Set the position of a node
  def position
    resource.insert_at(params[:position].to_i)
    respond_with(resource) do |format|
      format.json { render :json => resource_as_json }
    end
  end
  
  private

  # Returns the node collection in JSON format.
  #
  # @return [ String ] The node collection JSON.
  def collection_as_json
    collection.collect(&:to_simplified_json).to_json
  end

  # Returns the node resouce in JSON format.
  #
  # @return [ String ] The node JSON.
  def resource_as_json
    resource.to_simplified_json.to_json
  end

end

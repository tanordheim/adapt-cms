# encoding: utf-8

class Api::Version1::ApiController < ApplicationController #:nodoc

  # Don't do maintenance checks on API requests.
  skip_before_filter :check_for_maintenance_mode
  
  # Don't verify authenticity token on API requests.
  skip_before_filter :verify_authenticity_token
  
  # Authenticate an administrator on all API requests.
  before_filter :authenticate_admin!

  # This version of the API only responds to JSON.
  respond_to :json

  # Expose the currently requested resource, if any.
  expose(:resource) { load_resource }

  # Expose the currently requested collection, if any.
  expose(:collection) { load_collection }

  # We trap ActiveRecord::RecordNotFound exceptions and return a properly
  # formatted JSON message instead.
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :json => {:message => 'Resource not found'}.to_json, :status => 404
  end

  # Default index action. Returns the requested model collection in JSON format.
  def index
    respond_with(collection) do |format|
      format.json { render :json => collection_as_json }
    end
  end

  # Default show action. Returns the requested model in JSON format.
  def show
    respond_with(resource) do |format|
      format.json { render :json => resource_as_json }
    end
  end

  # Default create action. Creates the requested model with the data passed in
  # from the client.
  #
  # If the create was successful, a 200 OK response code and the created model
  # in JSON format is returned. If the create failed, the errors are returned in
  # JSON format together with a 422 Unprocessable Entity response code.
  def create

    record_author(:creator, :updater)

    if resource.save
      respond_with(resource) do |format|
        format.json { render :json => resource_as_json }
      end
    else
      respond_with(resource.errors, :status => 422) do |format|
        format.json { render :json => resource.errors.to_json(error_collection_serialization_options), :status => 422 }
      end
    end

  end

  # Default update action. Updates the requested model with the data passed in
  # from the client. 
  #
  # If the update was successful, a 200 OK response code and an the updated
  # model in JSON format is returned. If the update failed, the errors are
  # returned in JSON format together with a 422 Unprocessable Entity response
  # code.
  def update

    record_author(:updater)

    if resource.update_attributes(filtered_params(resource))
      respond_with(resource) do |format|
        format.json { render :json => resource_as_json }
      end
    else
      respond_with(resource.errors, :status => 422) do |format|
        format.json { render :json => resource.errors.to_json(error_collection_serialization_options), :status => 422 }
      end
    end

  end

  # Default destroy action. Destroys the requested model.
  #
  # If the destruction was successful, a 200 OK response code and the destroyed
  # model in JSON format is returned. This action does not handle errors for the
  # time being.
  def destroy
    resource.destroy
    respond_with(resource) do |format|
      format.json { render :json => resource_as_json }
    end
  end

  protected

  # Returns the params hash from the request where attributes that are not valid
  # for the model have been filtered out.
  #
  # @returns [ Hash ] A hash of params.
  def filtered_params(model)

    # Remove all attributes that we don't have a setter for.
    filtered = params.reject { |key, value| !model.respond_to?(:"#{key}=") }

    # Remove some stuff we never want to be able to let the client set.
    exclude_fields = %w(id created_at updated_at creator_id updater_id)
    filtered.reject { |key, value| exclude_fields.include?(key.to_s) }

  end

  # Returns the object name for this request.
  #
  # @returns [ String ] The object name for this request.
  def object_name
    controller_name.singularize
  end

  # Returns the collection name for this request.
  #
  # @returns [ String ] The collection name for this request.
  def collection_name
    controller_name
  end

  # Returns the serialization options to use for single objects.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {}
  end

  # Returns the serialization options to use for collections of objects.
  #
  # @returns [ Hash ] Hash of serialization options.
  def collection_serialization_options
    {}
  end

  # Returns the serialization options to use for a collection of validation
  # errors for an object.
  #
  # @returns [ Hash ] Hash of serialization options.
  def error_collection_serialization_options
    {}
  end
  
  # Depending on the current action, build a new, unpersisted resource - or load
  # a pre-existing resource from the database.
  #
  # @returns [ ActiveRecord::Base ] The resource for the current request.
  def load_resource
    if new_actions.include?(params[:action].to_sym)
      build_resource
    elsif params[:id]
      find_resource
    end
  end

  # Build a new, unpersisted resource for the current request.
  #
  # @returns [ ActiveRecord::Base ] The newly built resource for the current
  #   request.
  def build_resource

    resource = collection.build
    resource.attributes = filtered_params(resource)

    # Set the site id from the parent node if it's not set on the model already.
    # This can for instance happen when building blog posts from the blog.posts
    # method (returning an ActiveRecord::Relation).
    resource.site_id = current_site.id if resource.respond_to?(:site_id=) && resource.send(:site_id).blank?

    resource

  end

  # Loads a pre-existing resource from the database.
  #
  # @return [ ActiveRecord::Base ] The loaded resource.
  def find_resource
    collection.find(params[:id])
  end

  # Defines the parent for the data handled by this controller. This defaults to
  # the current site.
  #
  # @return [ ActiveRecord::Base ] The parent model.
  def parent
    current_site
  end

  # Load the collection for this controller from the database.
  #
  # @returns [ Array ] An array of ActiveRecord::Base objects.
  def load_collection
    parent.send(collection_name).includes(eager_load_associations)
  end

  # Returns a list of association names that should be eager loaded for the
  # collection.
  #
  # @returns [ Array ] An array of association names.
  def eager_load_associations
    nil
  end

  # Returns a list of actions classified as "new"-actions in a RESTful setting.
  #
  # @return [ Array] An array of "new"-actions
  def new_actions
    [:new, :create]
  end

  # Returns the current collection in JSON format.
  # 
  # @return [ String ] The current collection JSON.
  def collection_as_json
    collection.to_json(collection_serialization_options)
  end

  # Returns the current resource in JSON format.
  #
  # @return [ String ] The current resource JSON.
  def resource_as_json
    resource.to_json(object_serialization_options)
  end

  # Records the author of a change to the current resource if the resource
  # supports it.
  def record_author(*roles)

    return unless admin_signed_in?
    roles.each do |role|
      writer = :"#{role}="
      resource.send(writer, current_admin) if resource.respond_to?(writer)
    end

  end

end

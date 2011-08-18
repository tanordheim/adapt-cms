# encoding: utf-8

# This is the base controller for any controller that wishes to database backed
# data to the client as a static resource.
#
# This controller handles caching and sending the appropriate headers to
# optimize how browsers and proxies are caching these resources.
class StaticResourceController < ApplicationController

  layout nil
  skip_before_filter :check_for_maintenance_mode
  skip_before_filter :verify_authenticity_token

  # Handles the request for this resource.
  def show

    # Define cache headers that lets the content be cached in 350 days.
    # Cache busters in the path to the static resources will make sure they are
    # invalidating when chanced, since the URL will change.
    response.headers['Cache-Control'] = 'public, max-age=30240000'

    render :text => resource_data, :content_type => content_type

  end

  protected

  # Returns the data of the resource that we need to serve. This must be
  # implemented in each sub class.
  def resource_data
    raise ArgumentError.new 'The resource_data method must be implemented by the resource controller'
  end

  # Returns the content type that needs to be used to serve the resource. This
  # will default to application/octet-stream if the sub class does not override
  # this method.
  def content_type
    'application/octet-stream'
  end

end

# encoding: utf-8

class AdminController < ApplicationController #:nodoc

  # Don't do maintenance checks on admin requests.
  skip_before_filter :check_for_maintenance_mode
  
  # Authenticate an administrator on all admin requests.
  before_filter :authenticate_admin!

  # Verify that the admin actually has access to this site.
  before_filter :verify_admin_privileges!

  # Show the administration UI. All operations in the UI are handled via the
  # RESTful API, this is only to kickstart the Backbone.js UI.
  def show
  end

  private

  def verify_admin_privileges!
    raise NoPrivilegesError.new unless current_admin.has_privileges_for?(current_site)
  end
  
end

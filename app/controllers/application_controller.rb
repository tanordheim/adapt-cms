# encoding: utf-8
class ApplicationController < ActionController::Base #:nodoc

  protect_from_forgery

  before_filter :assign_site
  after_filter :unassign_site
  helper_method :current_site

  before_filter :check_for_maintenance_mode
  skip_before_filter :check_for_maintenance_mode, :if => :devise_controller? # Allow maintenance mode check through if we're in authentication

  # Rescue certain errors and present the user with a nice error page.
  #
  # Page not found-errors.
  rescue_from ActiveRecord::RecordNotFound do |error|
    display_error_page 'The page you requested could not be found.', 404
  end
  rescue_from InvalidSiteError do |error|
    display_error_page 'The site you requested could not be identified.', 404
  end

  # Permission errors.
  rescue_from NoPrivilegesError do |error|
    display_error_page 'You don\'t have the neccesary privileges to perform administrative tasks on this site.', 403
  end
  
  # Delivery errors.
  rescue_from MaintenanceModeError do |error|
    display_error_page 'The site you requested is currently down for maintenance. To view the site content you must either log in as a site administrator, or wait until an administrator has ended the maintenance mode.', 503
  end
  rescue_from NoDesignError do |error|
    display_error_page 'The site you requested has no default design available. Please contact the site owner if the problem persists.', 500
  end
  rescue_from NoViewTemplateError do |error|
    display_error_page 'The template for the content you requested could not be found. Please contact the site owner if the problem persists.', 500
  end

  private

  # Display an error page to the user.
  def display_error_page(message, error_code)
    self.status = error_code
    self.content_type = 'text/html'
    render :partial => '/shared/error_notification', :layout => 'notification', :locals => {:message => message, :error_code => error_code}
  end

  # Returns the current site for this request.
  #
  # @return [ Site ] The current site for this request.
  def current_site
    Site.current
  end

  # Assigns the site for this request.
  #
  # @raise [ Errors::InvalidSite ] If the current site could not be identified.
  #
  # @return [ Site ] The site for this request.
  def assign_site

    host = request.host

    # Attempt to load this site from the cache. If it fails, we'll do a more
    # specific lookup inside to block to figure out what site this actually is.
    site = Rails.cache.fetch "site:#{host}" do

      loaded_site = nil

      # If this site seems to be loaded via the app host, find the site matching
      # the requested subdomain. Otherwise, try matching a full hostname to the
      # site.
      if host_is_app_host?(host)
        subdomain = request.subdomains.first.present? ? request.subdomains.first : nil
        loaded_site = Site.with_design_data.find_by_subdomain(subdomain)
      end

      # If the site is still blank after the original lookup, try matching the
      # entire hostname. This is done separately instead of in a "else" block
      # since there are occurences of sites that have hostnames mapped to
      # <something>.adaptapp.com - for instance the Adapt primary website which
      # lives at www.adaptapp.com even though the subdomain host would be
      # adapt.adaptapp.com.
      if loaded_site.blank?
        loaded_site = Site.with_design_data.by_hostname(host).first
      end

      loaded_site

    end

    if site.blank?
      raise InvalidSiteError.new(host)
    else

      # If the site is requested with another host than the primary host for the
      # site, do a redirect with a 301 header to indicate that the content lives
      # on another host.
      if Rails.env.production? && host != site.default_host
        new_location = "http://#{site.default_host}#{request.path}"
        redirect_to new_location, :status => :moved_permanently
        return false
      end

      Site.current = site

    end

    Site.current

  end

  # Checks if the specified hostname is a registered app host for the
  # application.
  def host_is_app_host?(hostname)
    hostname == "adapt.127.0.0.1.xip.io"
  end

  # Unassigns the site for this request.
  def unassign_site
    Site.current = nil
  end

  # Returns the after sign in-path Devise should use if no other path is stored.
  def after_sign_in_path_for(resource_or_scope)
    return '/admin/' if !resource_or_scope.blank? && resource_or_scope.is_a?(Admin)
    super
  end

  # Check if the current site is in maintenance mode. If it is, and the current
  # administrator, if any, doesn't have access to the site, raise an error.
  def check_for_maintenance_mode
    if current_site.maintenance_mode?
      unless admin_signed_in? && current_admin.has_privileges_for?(current_site)
        raise MaintenanceModeError.new
      end
    end
  end
  
end

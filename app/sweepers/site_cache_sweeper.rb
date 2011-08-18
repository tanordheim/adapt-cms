# encoding: utf-8

# Handles sweeping cache for site related data.
class SiteCacheSweeper < ActionController::Caching::Sweeper

  observe Site, SiteHost, Design, ViewTemplate, IncludeTemplate

  @@sites = {}

  # Before updating a site, take a copy of the original one, including
  # hostnames, so we can correctly expire cache on the original site hosts.
  def before_update(resource)
    @@sites[site_id] = Site.find(load_site_from_resource(resource).id).freeze
  end

  # Load the site model from the specified resource
  def load_site_from_resource(resource)
    case resource.class.name
    when 'Site'
      resource
    when 'SiteHost', 'Design'
      resource.site
    when 'ViewTemplate', 'IncludeTemplate'
      resource.design.site
    end
  end

  # After save callback, sweeps the cache of any occurences of the site
  # definition associated with the resource.
  def after_save(resource)
    site = load_site_from_resource(resource)
    sweep(site)
  end

  # After destroy callback, sweeps the cache of any occurences of the site
  # definition associated with the resource.
  def after_destroy(resource)
    site = load_site_from_resource(resource)
    sweep(site)
  end

  private

  # Sweep all cached site definitions for the specified site.
  def sweep(site)

    original = @@sites.delete(site.id)

    # Expire the cache of the site object based on its hostnames.
    hosts = hosts_for_site(site)
    if original
      hosts += hosts_for_site(original)
      hosts = hosts.sort.uniq
    end

    hosts.each do |host|
      Rails.logger.debug("Purging site cache for host #{host}")
      Rails.cache.delete("site:#{host}")
    end

    Rails.logger.debug("Purging site liquid cache for site #{site.id}")
    Rails.cache.delete("site_liquid:#{site.id}")

  end

  # Returns an array of hosts for the specified site.
  def hosts_for_site(site)
    hosts = site.hosts.collect(&:hostname)
    hosts += Rails.env.production? ? ["#{site.subdomain}.adaptapp.com"] : ["#{site.subdomain}.adapt.dev"]
    hosts
  end
    
end

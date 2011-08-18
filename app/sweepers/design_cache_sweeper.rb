# encoding: utf-8

# Handles sweeping cache for all design related assets.
class DesignCacheSweeper < ActionController::Caching::Sweeper
  observe Javascript, Stylesheet, DesignResource

  @@javascripts = {}
  @@stylesheets = {}
  @@design_resources = {}

  # Before updating a resource, we take a copy of the original one so we can
  # correctly expire cache on the original resource filename.
  def before_update(resource)
    if resource.is_a?(Javascript)
      @@javascripts[resource.id] = Javascript.find(resource.id).freeze
    elsif resource.is_a?(Stylesheet)
      @@stylesheets[resource.id] = Stylesheet.find(resource.id).freeze
    elsif resource.is_a?(DesignResource)
      @@design_resources[resource.id] = DesignResource.find(resource.id).freeze
    end
  end

  # After save callback, sweeps the cache of the currently created or updated
  # resource.
  def after_save(resource)
    sweep_asset(resource)
  end

  # After destroy callback, sweeps the cache of the currently destroyed
  # resource.
  def after_destroy(resource)
    sweep_asset(resource)
  end

  private

  # Sweep the cache for the specified resource.
  def sweep_asset(resource)
    sweep_javascript(resource) if resource.is_a?(Javascript)
    sweep_stylesheet(resource) if resource.is_a?(Stylesheet)
    sweep_design_resource(resource) if resource.is_a?(DesignResource)
  end

  # Sweep the cache for a javascript.
  def sweep_javascript(javascript)

    original = @@javascripts.delete(javascript.id)
    delete_javascript_cache(javascript)
    delete_javascript_cache(original) unless original.blank?

  end

  # Delete the cache for the specified javascript
  def delete_javascript_cache(javascript)

    Rails.logger.debug("Purging cache for javascript #{javascript.filename} and design #{javascript.design_id}")
    key = "javascript:#{javascript.design_id}:#{javascript.filename}"
    Rails.cache.delete(key)

  end

  # Sweep the cache for a stylesheet.
  def sweep_stylesheet(stylesheet)
    
    original = @@stylesheets.delete(stylesheet.id)
    delete_stylesheet_cache(stylesheet)
    delete_stylesheet_cache(original) unless original.blank?
    
  end

  # Delete the cache for the specified stylesheet
  def delete_stylesheet_cache(stylesheet)

    Rails.logger.debug("Purging cache for stylesheet #{stylesheet.filename} and design #{stylesheet.design_id}")
    key = "stylesheet:#{stylesheet.design_id}:#{stylesheet.filename}"
    Rails.cache.delete(key)
  end

  # Sweep the cache for a design resource.
  def sweep_design_resource(design_resource)

    original = @@design_resources.delete(design_resource.id)
    delete_design_resource_cache(design_resource)
    delete_design_resource_cache(original) unless original.blank?
    
  end

  # Delete the cache for the specified design resource
  def delete_design_resource_cache(design_resource)

    Rails.logger.debug("Purging cache for design resource #{design_resource.filename} and design #{design_resource.design_id}")
    key = "design_resource:#{design_resource.design_id}:#{design_resource.filename}"
    Rails.cache.delete(key)

  end
  
end

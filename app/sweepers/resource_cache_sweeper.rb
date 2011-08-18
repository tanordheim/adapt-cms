# encoding: utf-8

# Handles sweeping cache for all resource related data.
class ResourceCacheSweeper < ActionController::Caching::Sweeper
  observe Resource

  # After save-callback, sweeps the cache of the saved resource.
  def after_save(resource)
    sweep(resource)
  end

  private

  # Sweeps the cache for the specified resource.
  def sweep(resource)
    Rails.logger.debug("Purging cache for resource #{resource.id} and site #{resource.site_id}")
    Rails.cache.delete("resource:#{resource.site_id}:#{resource.id}")
  end
end

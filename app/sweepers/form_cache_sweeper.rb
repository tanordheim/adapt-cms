# encoding: utf-8

# Handles sweeping cache for all form related data.
class FormCacheSweeper < ActionController::Caching::Sweeper
  observe Form

  # After save-callback, sweeps the cache of the saved form.
  def after_save(form)
    sweep(form)
  end

  private

  # Sweeps the cache for the specified form.
  def sweep(form)
    Rails.logger.debug("Purging cache for form #{form.id} and site #{form.site_id}")
    Rails.cache.delete("form:#{form.site_id}:#{form.id}")
  end

end

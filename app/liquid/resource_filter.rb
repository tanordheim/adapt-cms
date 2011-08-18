# Resource filter

module ResourceFilter

  # Returns the liquified resource based on the input id
  def resource(input)

    site_id = @context['__site_id']

    # Attempt to locate the resource.
    resource = Rails.cache.fetch "resource:#{site_id}:#{input}" do
      r = Resource.where(:site_id => site_id).where(:id => input.to_i).first
      r.blank? ? nil : r.to_liquid
    end

    resource

  end

end

class ResourceLinkTag < BaseTag

  # Render the resource link tag.
  def render(context)

    site_id = context['__site_id']

    # Attempt to locate the resource.
    resource = Rails.cache.fetch "resource:#{site_id}:#{@params['id']}" do
      r = Resource.where(:site_id => site_id).where(:id => @params['id'].to_i).first
      r.blank? ? nil : r.to_liquid
    end
    return nil if resource.blank?

    markup = "<a href=\"#{h(resource['url'])}\""

    # Title tag
    if @params['title']
      markup += " title=\"#{h(@params['title'])}\""
    else
      markup += " title=\"#{h(resource['title'])}\""
    end

    # Class tag
    if @params['class']
      markup += " class=\"#{h(@params['class'])}\""
    end

    # Id tag
    if @params['id']
      markup += " id=\"#{h(@params['id'])}\""
    end

    markup += ">"

    # Link text
    if @params['label']
      markup += h(@params['label'])
    else
      markup += h(resource['filename'])
    end

    markup += '</a>'
    markup

  end

end

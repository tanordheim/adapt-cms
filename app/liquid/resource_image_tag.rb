class ResourceImageTag < BaseTag

  # Render the resource image tag.
  def render(context)

    site_id = context['__site_id']

    # Attempt to locate the resource.
    resource = Rails.cache.fetch "resource:#{site_id}:#{@params['id']}" do
      r = Resource.where(:site_id => site_id).where(:id => @params['id'].to_i).first
      r.blank? ? nil : r.to_liquid
    end
    return nil if resource.blank?

    markup = "<img src=\"#{h(resource['url'])}\""

    # Alt-tag
    if @params['alt']
      markup += " alt=\"#{h(@params['alt'])}\""
    else
      markup += " alt=\"#{h(resource['filename'])}\""
    end

    # Class-tag
    if @params['class']
      markup += " class=\"#{h(@params['class'])}\""
    end

    # Id-tag
    if @params['id']
      markup += " id=\"#{h(@params['id'])}\""
    end

    markup += " />"

    # Handle linking of the image resource.
    if @params['link_to_resource']

      # Attempt to locate the resource.
      linked_resource = Rails.cache.fetch "resource:#{site_id}:#{@params['link_to_resource']}" do
        r = Resource.where(:site_id => site_id).where(:id => @params['link_to_resource'].to_i).first
        r.blank? ? nil : r.to_liquid
      end

      if linked_resource
        markup = "<a href=\"#{h(linked_resource['url'])}\">#{markup}</a>"
      end
    elsif @params['link_to']
      markup = "<a href=\"#{h(@params['link_to'])}\">#{markup}</a>"
    end


    markup

  end
  
end

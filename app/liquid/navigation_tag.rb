class NavigationTag < BaseTag

  # Render the navigation tag
  def render(context)

    navigation_elements = context[@params['nodes']]

    current_class = @params['current_class'] || 'current'
    id = @params['id'] || ''

    current_node = context['node'] ? context['node']['id'] : nil
    current_node_ancestors = context['node'] ? context['node']['ancestors'].collect { |ancestor| ancestor['id'] } : []

    markup = "<ul"
    markup += " id=\"#{h(id)}\"" unless id.blank?
    markup += ">\n"

    navigation_elements.each do |element|

      markup += "  <li"
      markup += " class=\"#{h(current_class)}\"" if element['id'] == current_node || current_node_ancestors.include?(element['id'])
      markup += ">"

      markup += "<a href=\"/#{h(element['uri'])}\" title=\"#{element['name']}\">"
      markup += element['name']
      markup += "</a>"

      markup += "</li>\n"

    end

    markup += "</ul>"
    markup
    
  end

end

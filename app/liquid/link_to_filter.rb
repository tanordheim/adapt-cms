# Link To-filter
# Builds a link to a node within the site.

module LinkToFilter

  def link_to(node)
    return nil if node.blank?
    "<a href=\"/#{h(node['uri'])}\" title=\"#{h(node['name'])}\">#{h(node['name'])}</a>"
  end

end

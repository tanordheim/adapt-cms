# This is the main point of invocation for rendering a node within Adapt. It
# takes a design and a view template and merge them together for a complete page
# layout.

class NodeRenderer

  # Initialize a new renderer.
  def initialize(design, view_template, site, node)
    @design = design
    @view_template = view_template
    @node = node
    @site = site
  end

  # Return the assembled markup for the node
  def markup
    @markup ||= assemble_markup
  end

  private

  # Assemble the markup for the current page
  def assemble_markup

    design_renderer = liquid_for(@design.markup)
    view_renderer = liquid_for(@view_template.markup)
    params = node_template_data.merge(global_template_data)

    # Render the view template.
    rendered_view = view_renderer.render(params, :filters => liquid_filters)

    # Render the design and merge in the view.
    design_renderer.render(params.merge('content' => rendered_view), :filters => liquid_filters)

  end

  # Returns the template data for the current node.
  def node_template_data
    {'node' => @node, @node['classification'] => @node}
  end

  # Returns the global template data.
  def global_template_data
    {'site' => @site, '__design_id' => @design.id, '__site_id' => @site['id']}
  end

  # Returns a new Liquid template for the specified template markup.
  def liquid_for(markup)
    Liquid::Template.file_system = IncludeTemplateFileSystem.new(@design)
    Liquid::Template.register_tag('navigation', NavigationTag)
    Liquid::Template.register_tag('resource_link', ResourceLinkTag)
    Liquid::Template.register_tag('resource_image', ResourceImageTag)
    Liquid::Template.register_tag('search', SearchBlock)
    Liquid::Template.parse(markup)
  end

  # Returns an array of Liquid filters to apply when rendering a node.
  def liquid_filters
    [
      StylesheetFilter,
      JavascriptFilter,
      AssignToFilter,
      LinkToFilter,
      GoogleAnalyticsFilter,
      GoogleWebmasterToolsFilter,
      GoogleJavascriptFilter,
      TextileFilter,
      DesignResourceFilter,
      AttributeFilter,
      ResourceFilter,
      NodeFilter,
      FormFilter
    ]
  end

  # Returns an array of Liquid filters to apply when rendering content in a
  # view.
  def liquid_view_filters
    []
  end

end

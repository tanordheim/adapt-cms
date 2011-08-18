class NodesController < ApplicationController

  expose(:node) { requested_node }
  expose(:node_uri) { params[:path] }

  def show

    # Load the Liquid representation of the requested node.
    node_liquid = Rails.cache.fetch "node:#{current_site.id}:#{node_uri}" do
      requested_node.to_liquid
    end

    # Load the Liquid representation of the current site.
    site_liquid = Rails.cache.fetch "site_liquid:#{current_site.id}" do
      current_site.to_liquid
    end

    # Load the design
    design = current_site.default_design
    raise NoDesignError.new if design.blank?

    # Find the template for this node
    template_name = node_liquid['view']
    template = design.view_templates.select { |t| t.filename == template_name }.first
    raise NoViewTemplateError.new if template.blank?

    # Render the page
    renderer = NodeRenderer.new(design, template, site_liquid, node_liquid)
    render :text => renderer.markup

  end

  private

  # Returns the requested node.
  def requested_node

    scope = current_site.nodes.with_attributes.with_variant

    # If we have no path, use the first root page. Otherwise, find the page by
    # the requested URI.
    if node_uri.blank?

      home_page = scope.sorted.roots.first
      raise ActiveRecord::RecordNotFound.new if home_page.blank?
      home_page

    else
      scope.find_by_uri!(node_uri)
    end

  end

end

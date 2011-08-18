# Pre-renders a stylesheet before its passed on to a CSS processor.

class StylesheetRenderer

  # Initialize a new renderer.
  def initialize(stylesheet)
    @stylesheet = stylesheet
  end

  # Return the assembled CSS for the node.
  def css
    @css ||= assemble_css
  end

  private

  # Assemble the CSS for the current stylesheet.
  def assemble_css
    renderer = Liquid::Template.parse(@stylesheet.data)
    renderer.render(global_template_data, :filters => liquid_filters)
  end

  # Returns an array of Liquid filters to apply when rendering a stylesheet.
  def liquid_filters
    [
      DesignResourceFilter,
      AttributeFilter
    ]
  end

  # Returns the global template data for any stylesheet template.
  def global_template_data
    {'__design_id' => @stylesheet.design_id}
  end

end

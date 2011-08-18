# Stylesheet filter
# Assembles the link for a stylesheet in the design

module StylesheetFilter

  def stylesheet(input)

    # Load the requested stylesheet.
    design_id = @context['__design_id']
    stylesheet = Rails.cache.fetch "stylesheet:#{design_id}:#{input}" do
      Stylesheet.where(:design_id => design_id).find_by_filename(input)
    end

    # If no stylesheet could be loaded, don't render anything.
    return nil if stylesheet.blank?

    path = "/d/#{design_id}-#{stylesheet.updated_at.to_i}/s/#{input}.css"
    "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{h(path)}\" media=\"screen\" />"

  end

end

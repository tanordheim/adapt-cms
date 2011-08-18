# Javascript filter
# Assembles the include for a javascript in the design

module JavascriptFilter

  def javascript(input)

    # Load the requested javascript.
    design_id = @context['__design_id']
    javascript = Rails.cache.fetch "javascript:#{design_id}:#{input}" do
      Javascript.where(:design_id => design_id).find_by_filename(input)
    end

    # If no javascript could be loaded, don't render anything.
    return nil if javascript.blank?

    path = "/d/#{design_id}-#{javascript.updated_at.to_i}/j/#{input}.js"
    "<script type=\"text/javascript\" src=\"#{h(path)}\" encoding=\"utf-8\"></script>"

  end

end

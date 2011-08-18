# Textile filter
# Renders Textile markup to HTML

module TextileFilter

  def textilize(text)
    renderer = TextileRenderer.new(text)
    renderer.parsed_text
  end

end

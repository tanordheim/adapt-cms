# This is the main point of invocation for rendering textile based text into a
# view. It will first parse the text through Liquid, with support for certain
# tags used in the CMS administration - then passes it through RedCloth for
# parsing.

class TextileRenderer

  def initialize(text)
    @text = text
  end

  def parsed_text
    @parsed_text ||= parse_text
  end

  private

  # Parse the current text.
  def parse_text

    template = Liquid::Template.parse(@text)
    parsed_text = template.render(global_template_data)
    RedCloth.new(parsed_text).to_html

  end

  # Returns the global template data.
  def global_template_data
    {'site' => Site.current, '__site_id' => Site.current.id}
  end

end

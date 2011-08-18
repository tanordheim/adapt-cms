module HandlebarsTemplateHelper

  # Render a Handlebars template to the view inside a <script /> tag.
  def render_handlebars_template(id, partial = nil)

    partial = id if partial.blank?

    template = render :partial => partial
    content_tag(:script, template, :type => 'text/x-handlebars-template', :'data-id' => id)

  end

end

# Form filter

module FormFilter

  DEFAULT_FORM_TEMPLATE = %q|<form action="{{ form.uri }}" method="post">
  <fieldset>
    <ol>
      {% for field in form.fields %}
        <li class="{{ field.classification }}">
          <label for="{{ field.id}}">{{ field.name }}</label>
          
          {% if field.classification == 'string_field' %}
          <input type="text" name="{{ field.id }}" id="{{ field.id }}-field" value= "" />
          {% elsif field.classification == 'text_field' %}
          <textarea name="{{ field.id }}" id="{{ field.id }}-field"></textarea>
          {% elsif field.classification == 'select_field' %}
          <select name="{{ field.id }}" id="{{ field.id }}-field">
            {% if field.default_text %}
            <option value="">{{ field.default_text }}</option>
            {% endif %}
            {% for option in field.options %}
            <option value="{{ option }}">{{ option }}</option>
            {% endfor %}
          </select>
          {% elsif field.classification == 'check_box_field' %}
          <ol>
            {% for option in field.options %}
            <li>
              <label>
                <input type="checkbox" name="{{ field.id }}[]" id="{{ field.id }}-field" value="{{ option }}" />
                {{ option }}
              </label>
            </li>
            {% endfor %}
          </ol>
          {% endif %}
          
        </li>
      {% endfor %}
    </ol>
  </fieldset>
  <fieldset class="buttons">
    <ol>
      <li><label></label><input type="submit" value="{{ form.submit_text }}" /></li>
    </ol>
  </fieldset>
</form>|

  # Returns the liquified node based on the input id
  def form(input)

    site_id = @context['__site_id']
    form_id = input.to_i

    # Attempt to locate the form in the database
    form = Rails.cache.fetch "form:#{site_id}:#{input}" do
      f = Form.with_fields.where(:site_id => site_id).where(:id => input.to_i).first
      f.blank? ? nil : f.to_liquid
    end

    form

  end

  # Render a form
  def render_form(input)
    Liquid::Template.parse(DEFAULT_FORM_TEMPLATE).render({ 'form' => input })
  end

end

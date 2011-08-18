# Attribute filter
# Returns the value of the specified attribute from the input data.

module AttributeFilter

  def attribute(input, attribute_name)
    if !input.blank? && input.is_a?(Hash) && input.key?(attribute_name)
      input[attribute_name]
    else
      nil
    end
  end

end

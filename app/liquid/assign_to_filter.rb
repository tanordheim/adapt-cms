# Assign To-filter
# Assigns the output of a macro to the context

module AssignToFilter

  def assign_to(input, variable_name)
    @context.environments.first[variable_name] = input
    nil
  end

end

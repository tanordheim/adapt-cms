$(document).ready ->
  $('body').ajaxError (event, response, settings, exception) ->
    if response.status == 422

      validation_errors = eval "(#{response.responseText})"
      message_text = "Validation failed:\n\n"
      
      # Extract all validation errors.
      fields = _.keys validation_errors
      for field in fields
        errors = validation_errors[field]
        for error in errors
          message_text += "#{field}: #{error}\n"

      alert message_text

    else
      alert "Unknown error #{response.status} raised by server"

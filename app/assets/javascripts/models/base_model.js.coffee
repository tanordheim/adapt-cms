class App.Backbone.BaseModel extends Backbone.Model

  defaults: {}

  # Returns the API path for the specified service.
  apiPath: (path) ->
    "/api/v1/#{path}"

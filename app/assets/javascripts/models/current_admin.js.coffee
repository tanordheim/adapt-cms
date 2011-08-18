class App.Models.CurrentAdmin extends App.Backbone.BaseModel

  # Returns the URL for the admin.
  url: =>
    @apiPath 'admin'

class App.Models.CurrentSite extends App.Backbone.BaseModel

  # Returns the URL for the site.
  url: =>
    @apiPath 'site'

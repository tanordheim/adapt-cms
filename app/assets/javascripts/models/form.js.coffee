class App.Models.Form extends App.Backbone.BaseModel

  # Returns the URL for this form
  url: =>
    if @isNew()
      @apiPath 'forms'
    else
      @apiPath "forms/#{@get 'id'}"

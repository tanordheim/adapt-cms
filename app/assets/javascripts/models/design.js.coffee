class App.Models.Design extends App.Backbone.BaseModel

  # Returns the URL for this design
  url: =>
    if @isNew()
      @apiPath 'designs'
    else
      @apiPath "designs/#{@get 'id'}"

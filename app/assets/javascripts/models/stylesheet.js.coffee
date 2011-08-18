class App.Models.Stylesheet extends App.Backbone.BaseModel

  defaults:
    filename: ''
    data: ''

  # Returns the URL for this javascript
  url: =>
    if @isNew()
      @apiPath "designs/#{@get 'design_id'}/stylesheets"
    else
      @apiPath "designs/#{@get 'design_id'}/stylesheets/#{@get 'id'}"

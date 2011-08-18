class App.Models.Javascript extends App.Backbone.BaseModel

  defaults:
    filename: ''
    data: ''

  # Returns the URL for this javascript
  url: =>
    if @isNew()
      @apiPath "designs/#{@get 'design_id'}/javascripts"
    else
      @apiPath "designs/#{@get 'design_id'}/javascripts/#{@get 'id'}"

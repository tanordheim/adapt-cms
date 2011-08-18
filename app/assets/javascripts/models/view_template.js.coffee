class App.Models.ViewTemplate extends App.Backbone.BaseModel

  defaults:
    filename: ''
    markup: ''

  # Returns the URL for this view template
  url: =>
    if @isNew()
      @apiPath "designs/#{@get 'design_id'}/view_templates"
    else
      @apiPath "designs/#{@get 'design_id'}/view_templates/#{@get 'id'}"

class App.Models.IncludeTemplate extends App.Backbone.BaseModel

  defaults:
    filename: ''
    markup: ''

  # Returns the URL for this include template
  url: =>
    if @isNew()
      @apiPath "designs/#{@get 'design_id'}/include_templates"
    else
      @apiPath "designs/#{@get 'design_id'}/include_templates/#{@get 'id'}"

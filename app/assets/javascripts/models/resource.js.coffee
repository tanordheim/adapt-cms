class App.Models.Resource extends App.Backbone.BaseModel

  # Returns the URL for this resource
  url: =>
    if @isNew()
      @apiPath 'resources'
    else
      @apiPath "resources/#{@get 'id'}"

  # Returns true if this resource is an image.
  isImage: =>
    @get('content_type').substring(0, 6) == 'image/'

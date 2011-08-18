class App.Collections.DesignResources extends App.Backbone.BaseCollection

  model: App.Models.DesignResource
  designId: null

  # Initialize the collection with a design id.
  initialize: (designId) =>
    @designId = designId

  # Returns the URL for this collection.
  url: =>
    "/api/v1/designs/#{@designId}/resources"

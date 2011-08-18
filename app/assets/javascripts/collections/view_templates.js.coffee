class App.Collections.ViewTemplates extends App.Backbone.BaseCollection

  model: App.Models.ViewTemplate
  designId: null

  # Initialize the collection with a design id.
  initialize: (designId) =>
    @designId = designId

  # Returns the URL for this collection.
  url: =>
    "/api/v1/designs/#{@designId}/view_templates"

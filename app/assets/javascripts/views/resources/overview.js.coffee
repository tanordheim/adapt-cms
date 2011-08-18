class App.Views.Resources.Overview extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'resources/overview'
    @collection.bind 'reset', @render

  render: =>

    # Reset any resource navigation state we might have.
    @triggerUIEvent 'content', 'resource_changed', null

    @renderTemplate 'resources/overview'
    @renderResources()

    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage resources', 'resources'
    @renderBreadcrumb()

    super()

  # Render all resources available in the collection
  renderResources: =>
    @collection.each (resource) =>
      view = new App.Views.Resources.Resource model: resource
      @$('#resources').append(view.render().el)

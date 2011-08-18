class App.Views.Resources.Edit extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'resources/edit'
    @model.bind 'change', @render
    @bindUIEvent 'resources', 'resource_updated', @reloadResource

  render: =>

    # Render the view.
    @renderTemplate 'resources/edit', @model.toJSON(), {image: @model.isImage()}

    # Inform about the current resource having changed.
    @triggerUIEvent 'content', 'resource_changed', @model.get('id')
    
    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage resources', 'resources'
    @addBreadcrumb @model.get('filename'), "resources/#{@model.get 'id'}"
    @renderBreadcrumb()
    
    super()

  # Something updated the resource, so we need to reload it
  reloadResource: =>
    @model.fetch()

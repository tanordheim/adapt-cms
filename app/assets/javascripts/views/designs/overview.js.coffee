class App.Views.Designs.Overview extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'designs/overview'
    @collection.bind 'reset', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed', null
    
    @renderTemplate 'designs/overview'

    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage designs', 'designs'
    @renderBreadcrumb()

    super()

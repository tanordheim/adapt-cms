class App.Views.Content.Overview extends App.Backbone.ContentView

  initialize: ->
    @render()

  render: =>

    # Reset any node navigation state we might have.
    @triggerUIEvent 'content', 'node_changed', []

    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage content', 'content'
    @renderBreadcrumb()

    # Add the template to the DOM.
    $(@el).html('')

    # Call the super class render.
    super()

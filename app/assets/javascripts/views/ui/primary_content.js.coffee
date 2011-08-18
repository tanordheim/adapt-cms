class App.Views.UI.PrimaryContent extends App.Backbone.BaseView

  el: '#primary-content'
  currentView: null

  initialize: ->
    @model.bind 'change:contentView', @render

  render: =>

    # Remove the current view if it exists to free it up.
    if @currentView?
      @currentView.remove()

    # Render the new view.
    @currentView = @model.get('contentView')
    $(@el).empty().append(@currentView.el)

    @

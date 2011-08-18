class App.Views.Designs.NavigatorActions extends App.Views.NavigatorActionsBaseView

  initialize: ->
    super 'designs'
    @render()

  render: =>
    addView = new AddDesignActionView
    $(@el).append addView.render().el
    @

# This is a local view that defines the add link for the design navigator view.
class AddDesignActionView extends App.Backbone.BaseView

  tagName: 'li'

  events:
    'click a': 'addNewDesign'

  render: =>
    link = $('<a/>')
    link.text 'Add new design'
    $(@el).append link
    $(@el).addClass 'add'

    @

  addNewDesign: =>
    @redirectTo 'designs/new'

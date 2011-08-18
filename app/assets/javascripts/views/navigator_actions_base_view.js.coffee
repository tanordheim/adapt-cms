class App.Views.NavigatorActionsBaseView extends App.Backbone.BaseView

  # Parent element for all navigator actions
  parent: '#navigator-actions'

  #
  # Initialize a navigator action view.
  #
  initialize: (navigatorActionId) ->
    @navigatorActionId = navigatorActionId
    @defineNavigatorActionContainer()

  #
  # Define the container (@el) for these navigator actions. If the element
  # doesn't exist, create it.
  #
  defineNavigatorActionContainer: ->
    if $("ul##{@navigatorActionId}-navigator-actions", $(@parent)).length == 0
      $(@parent).append("<ul id='#{@navigatorActionId}-navigator-actions' />")
    @el = "ul##{@navigatorActionId}-navigator-actions"

class App.Views.NavigatorBaseView extends App.Backbone.BaseView

  # Parent element for all navigators.
  parent: '#navigator'

  #
  # Initialize a navigator view
  #
  initialize: (navigatorId) ->
    @navigatorId = navigatorId
    @defineNavigatorContainer()

  #
  # Define the container (@el) for this navigator. If the element doesn't exist,
  # create it.
  #
  defineNavigatorContainer: ->
    if $("ul##{@navigatorId}-navigator", $(@parent)).length == 0
      $(@parent).append("<ul id='#{@navigatorId}-navigator' />")
    @el = "ul##{@navigatorId}-navigator"

class App.Views.Dashboard.Navigator extends App.Views.NavigatorBaseView

  initialize: ->
    @preloadTemplate 'dashboard/navigator'
    super 'dashboard'
    @render()

  render: ->
    @renderTemplate 'dashboard/navigator'

class App.Routers.DashboardRouter extends App.Backbone.BaseRouter

  routes:
    '': 'show'
    'dashboard': 'show'

  #
  # Before filter-implementation. Invoked before every action of this router.
  #
  before: ->

    # Set the current section.
    App.Data.UIState.setSection 'dashboard'
    
  #
  # Display the dashboard to the user.
  #
  show: ->
    activities = new App.Collections.Activities
    view = new App.Views.Dashboard.Overview collection: activities
    activities.fetch()

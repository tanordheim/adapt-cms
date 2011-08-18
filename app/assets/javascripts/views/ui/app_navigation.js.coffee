class App.Views.UI.AppNavigation extends App.Backbone.BaseView

  el: '#primary-nav'

  events:
    'click #dashboard-nav a': 'activateDashboardSection'
    'click #content-nav a': 'activateContentSection'
    'click #resources-nav a': 'activateResourcesSection'
    'click #designs-nav a': 'activateDesignsSection'

  activateDashboardSection: =>
    @redirectTo 'dashboard'

  activateContentSection: =>
    @redirectTo 'content'

  activateResourcesSection: =>
    @redirectTo 'resources'

  activateDesignsSection: =>
    @redirectTo 'designs'

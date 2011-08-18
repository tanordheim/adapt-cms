class App.Views.AppView extends App.Backbone.BaseView

  el: 'body'

  initialize: ->

    # Configure our UI events.
    App.Events.UIEvent = _.extend {}, Backbone.Events

    # Initialize some UI models.
    App.Data.UIState = new App.Models.UIState
    App.Data.UIBreadcrumbs = new App.Collections.UIBreadcrumbs

    # Initialize some data collections.
    App.Data.CurrentSite = new App.Models.CurrentSite
    App.Data.CurrentAdmin = new App.Models.CurrentAdmin
    App.Data.Nodes = new App.Collections.Nodes
    App.Data.PageVariants = new App.Collections.PageVariants
    App.Data.BlogVariants = new App.Collections.BlogVariants
    App.Data.BlogPostVariants = new App.Collections.BlogPostVariants
    App.Data.LinkVariants = new App.Collections.LinkVariants
    App.Data.Forms = new App.Collections.Forms
    App.Data.Resources = new App.Collections.Resources
    App.Data.Designs = new App.Collections.Designs

    # Preload some of our data.
    @preloadData 'Collections/Nodes', 'Collections/PageVariants', 'Collections/BlogVariants', 'Collections/BlogPostVariants', 'Collections/LinkVariants', 'Collections/Forms', 'Collections/Resources', 'Collections/Designs', 'Models/CurrentSite', 'Models/CurrentAdmin'

    # Initialize some view fragments.
    App.UI.AppNavigation = new App.Views.UI.AppNavigation model: App.Data.UIState
    App.UI.SiteNavigation = new App.Views.UI.SiteNavigation model: App.Data.CurrentAdmin
    App.UI.Breadcrumb = new App.Views.UI.Breadcrumb collection: App.Data.UIBreadcrumbs
    App.UI.PrimaryContent = new App.Views.UI.PrimaryContent model: App.Data.UIState
    App.UI.Notice = new App.Views.UI.Notice model: App.Data.UIState
    App.UI.Dialog = new App.Views.UI.Dialog

    # Initialize navigator and navigator action views.
    App.UI.DashboardboardNavigator = new App.Views.Dashboard.Navigator
    App.UI.ContentNavigator = new App.Views.Content.Navigator collection: App.Data.Nodes
    App.UI.ContentNavigatorActions = new App.Views.Content.NavigatorActions
    App.UI.ResourceNavigator = new App.Views.Resources.Navigator
    App.UI.DesignsNavigator = new App.Views.Designs.Navigator collection: App.Data.Designs
    App.UI.DesignsNavigatorActions = new App.Views.Designs.NavigatorActions

    # Bind to changes to the current section so we can display the appropriate
    # content.
    App.Data.UIState.bind 'change:currentSection', @changeSection

  # Show the full screen loading screen indicating that the application is
  # preloading.
  showLoadingScreen: ->

    # Configure the progress bar
    $('#loading-screen progress').attr('value', 0)
    $('#loading-screen progress').attr('max', @pendingDataRetrievals.length)

    # Show the loading screen
    $('#loading-screen').show()

  # Hide the full screen loading screen indicating that the application is no
  # longer preloading.
  hideLoadingScreen: ->
    $('#loading-screen').fadeOut(200)

  # Preload all the specified data attributes. This will display the fullscreen
  # loading screen and fire off fetch events for all the attributes specified.
  # When all data have been completely fetched, the loading screen is hidden.
  preloadData: (identifiers...) ->

    @pendingDataRetrievals = identifiers

    @showLoadingScreen()

    for identifier in identifiers
      [type, name] = identifier.split('/', 2)
      App.Data[name] = new App[type][name]
      App.Data[name].fetch
        success: =>

          resultIdentifier = "#{type}/#{name}"
          @pendingDataRetrievals.splice(@pendingDataRetrievals.indexOf(resultIdentifier), 1)

          # Update the progress bar
          remainingRetrievals = $('#loading-screen progress').attr('max') - @pendingDataRetrievals.length
          $('#loading-screen progress').attr('value', remainingRetrievals)

          # Hide the loading screen if we have no more pending data retrievals.
          if @pendingDataRetrievals.length == 0
            @hideLoadingScreen()

        error: (collection, response) =>
          alert('Unable to preload application data. The service might be down.')

  #
  # Change the current section of the view
  #
  changeSection: =>
    $(@el).attr('id', "#{App.Data.UIState.get 'currentSection'}-view")

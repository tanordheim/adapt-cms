window.App =
  Helpers: {}
  Backbone: {}
  Events: {}
  Models: {}
  Collections: {}
  Routers: {}
  Views:
    UI: {}
    Dashboard: {}
    Content: {}
    Resources: {}
    Designs: {}
    Admins: {}
  CompiledTemplates: {}

  AppView: null
  Data: {}
  UI: {}

  initialize: ->

    # If we are requested as /admin instead of /admin/, redirect to /admin/ to
    # make the routes work properly. This will force the application to reload.
    if window.location.pathname == '/admin'
      window.location.pathname = '/admin/'
      return

    for routerName, routerClass of App.Routers
      new App.Routers[routerName]()
    App.AppView = new App.Views.AppView
    Backbone.history.start pushState: true, root: '/admin/'

  browserIsCompatible: ->
    browserVersion = parseInt($.browser.version)

    # Support IE 9 or later.
    if $.browser.msie && browserVersion >= 9
      return true

    #  Support Firefox and Chrome/Safari
    if $.browser.mozilla || $.browser.webkit
      return true

    false

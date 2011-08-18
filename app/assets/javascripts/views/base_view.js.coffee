class App.Backbone.BaseView extends Backbone.View

  # Preload a template for this view.
  preloadTemplate: (templateId) =>

    # Don't do anything if the template is already compiled.
    return if App.CompiledTemplates[templateId]?

    templateContainer = $("script[data-id='#{templateId}']")
    if templateContainer.length == 0
      throw "Invalid template specified: #{templateId}"

    App.CompiledTemplates[templateId] = Handlebars.compile templateContainer.html()

  # Render a template to the primary content view
  renderTemplate: (templateId, data...) =>

    # Merge all our data sets into one associative array.
    templateData = {}
    _.each data, (dataSet) ->
      _.extend templateData, dataSet

    $(@el).empty().html App.CompiledTemplates[templateId](templateData)
    @

  # Show a dialog box to the user .
  showDialog: (name, view) =>
    @triggerUIEvent 'dialog', 'show',
      name: name
      view: view

  hideDialog: =>
    @triggerUIEvent 'dialog', 'hide'

  # Bind to an UI event
  bindUIEvent: (category, eventName, callback) =>
    App.Events.UIEvent.bind "#{category}:#{eventName}", callback

  # Trigger an UI event
  triggerUIEvent: (category, eventName, payload) =>
    App.Events.UIEvent.trigger "#{category}:#{eventName}", payload

  # Redirect the user to another URL within the Backbone application.
  redirectTo: (uri) =>
    Backbone.history.navigate uri, true

  # Show a notice in the view.
  showNotice: (message) =>
    App.Data.UIState.setNotice message

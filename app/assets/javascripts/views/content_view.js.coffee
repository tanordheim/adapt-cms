class App.Backbone.ContentView extends App.Backbone.BaseView

  breadcrumbBuffer: null

  # Add an item to the breadcrumb.
  addBreadcrumb: (label, path) ->
    @breadcrumbBuffer ||= []
    @breadcrumbBuffer.push new App.Models.UIBreadcrumb(label: label, path: path)

  # Fire an event to make the breadcrumb re-render
  renderBreadcrumb: ->
    App.Data.UIBreadcrumbs.reset @breadcrumbBuffer
    @breadcrumbBuffer = null

  # Render the primary content
  render: =>
    App.Data.UIState.setContentView @
    @

  # Enable Backbone ModelBinding for this view
  bindModels: =>
    Backbone.ModelBinding.bind @, all: 'name'

  # Configure a new MarkItUp editor.
  configureMarkItUpEditor: (editorSelector) =>
    console.log 'Configuring editors'
    editorSelector.markItUp window.MarkItUpSettings
    container = editorSelector.closest '.markItUpContainer'

    # Add click callback for the resource browser.
    $('.browse-for-resource', container).click (e) =>

      linkContainer = $(e.target).closest '.markItUpContainer'
      editor = $('.markItUpEditor', linkContainer)
      fieldName = editor.attr('data-field')
      dialogView = new App.Views.Resources.BrowseDialog selectedCallback: (resource) =>
        tag = if resource.isImage()
          "{% resource_image id:#{resource.get 'id'}"
        else
          "{% resource_link id:#{resource.get 'id'}"

        $.markItUp
          target: "##{editor.attr 'id'}"
          openWith: tag
          closeWith: "%}"

        # Trigger a change in the model.
        @model.data()[fieldName] = editor.val()
        @model.change()

      @showDialog 'Browse for resource', dialogView

  # Configure a new Ace editor.
  configureAceEditor: (element, mode, options = {}) =>

    # Instantiate the editor
    editor = ace.edit element
    editor.renderer.setShowPrintMargin false
    editor.renderer.setHScrollBarAlwaysVisible false
    editor.getSession().setUseWrapMode true

    # Change some settings based on the options.
    if options.showGutter? && options.showGutter == true
      editor.renderer.setShowGutter true
    else
      editor.renderer.setShowGutter false

    # Load and set the mode
    EditorMode = require("ace/mode/#{mode}").Mode
    EditorMode.prototype.createWorker = ->
      null
    editor.getSession().setMode new EditorMode()

    # Assign a change callback if we have one
    if options.onChange?
      editor.getSession().on 'change', =>
        value = editor.getSession().getValue()
        options.onChange value

    editor

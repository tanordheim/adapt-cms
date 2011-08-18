class App.Views.Designs.Javascripts extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'javascripts/overview'
    @model.bind 'change', @render
    @collection.bind 'reset', @render

  events:
    'click .new-javascript a': 'addNewJavascript'

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @model
      section: 'javascripts'
    
    # Render the template
    @renderTemplate 'javascripts/overview'

    # Render the javascript list
    @renderJavascripts()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @model.get('name'), "designs/#{@model.get 'id'}"
    @addBreadcrumb 'Javascripts', "designs/#{@model.get 'id'}/javascripts"
    @renderBreadcrumb()

    super()

  renderJavascripts: =>
    @collection.each (javascript) =>
      view = new JavascriptRow model: javascript, design: @model
      @$('table.javascripts tbody').append view.render().el

  addNewJavascript: =>
    @redirectTo "designs/#{@model.id}/javascripts/new"

# Local view that renders a javascript within the javascripts table
class JavascriptRow extends App.Backbone.BaseView

  tagName: 'tr'
  design: null

  events:
    'click a': 'showJavascript'

  initialize: (options) =>
    @design = options.design

  render: =>

    # Build the filename column
    filename = $('<td class="filename"/>')
    link = $('<a/>')
    link.text @model.get('filename')
    filename.append link
    $(@el).append filename

    # Build the size column
    size = $('<td class="size"/>')
    size.text App.Helpers.numberToHumanSize((@model.get('data') || '').length)
    $(@el).append size

    # Build the created at column
    createdAt = $('<td class="created-at"/>')
    createdAt.text App.Helpers.formatTimestamp(@model.get('created_at'))
    $(@el).append createdAt

    @

  showJavascript: =>
    @redirectTo "designs/#{@design.get 'id'}/javascripts/#{@model.get 'id'}"

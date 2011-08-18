class App.Views.Designs.Stylesheets extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'stylesheets/overview'
    @model.bind 'change', @render
    @collection.bind 'reset', @render

  events:
    'click .new-stylesheet a': 'addNewStylesheet'

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @model
      section: 'stylesheets'
    
    # Render the template
    @renderTemplate 'stylesheets/overview'

    # Render the stylesheet list
    @renderStylesheets()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @model.get('name'), "designs/#{@model.get 'id'}"
    @addBreadcrumb 'Stylesheets', "designs/#{@model.get 'id'}/stylesheets"
    @renderBreadcrumb()

    super()

  renderStylesheets: =>
    @collection.each (stylesheet) =>
      view = new StylesheetRow model: stylesheet, design: @model
      @$('table.stylesheets tbody').append view.render().el

  addNewStylesheet: =>
    @redirectTo "designs/#{@model.id}/stylesheets/new"

# Local view that renders a stylesheet within the stylesheets table
class StylesheetRow extends App.Backbone.BaseView

  tagName: 'tr'
  design: null

  events:
    'click a': 'showStylesheet'

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

  showStylesheet: =>
    @redirectTo "designs/#{@design.get 'id'}/stylesheets/#{@model.get 'id'}"

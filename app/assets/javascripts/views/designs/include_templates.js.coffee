class App.Views.Designs.IncludeTemplates extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'include_templates/overview'
    @model.bind 'change', @render
    @collection.bind 'reset', @render

  events:
    'click .new-template a': 'addNewTemplate'

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @model
      section: 'include-templates'
    
    # Render the template
    @renderTemplate 'include_templates/overview'

    # Render the template list
    @renderIncludeTemplates()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @model.get('name'), "designs/#{@model.get 'id'}"
    @addBreadcrumb 'Include templates', "designs/#{@model.get 'id'}/include_templates"
    @renderBreadcrumb()

    super()

  renderIncludeTemplates: =>
    @collection.each (includeTemplate) =>
      view = new IncludeTemplateRow model: includeTemplate, design: @model
      @$('table.include-templates tbody').append view.render().el

  addNewTemplate: =>
    @redirectTo "designs/#{@model.id}/include_templates/new"

# Local view that renders an include template within the include templates table
class IncludeTemplateRow extends App.Backbone.BaseView

  tagName: 'tr'
  design: null

  events:
    'click a': 'showTemplate'

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
    size.text App.Helpers.numberToHumanSize((@model.get('markup') || '').length)
    $(@el).append size

    # Build the created at column
    createdAt = $('<td class="created-at"/>')
    createdAt.text App.Helpers.formatTimestamp(@model.get('created_at'))
    $(@el).append createdAt

    @

  showTemplate: =>
    @redirectTo "designs/#{@design.get 'id'}/include_templates/#{@model.get 'id'}"

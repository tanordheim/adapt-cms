class App.Views.Designs.ViewTemplates extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'view_templates/overview'
    @model.bind 'change', @render
    @collection.bind 'reset', @render

  events:
    'click .new-template a': 'addNewTemplate'

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @model
      section: 'view-templates'
    
    # Render the template
    @renderTemplate 'view_templates/overview'

    # Render the template list
    @renderViewTemplates()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @model.get('name'), "designs/#{@model.get 'id'}"
    @addBreadcrumb 'View templates', "designs/#{@model.get 'id'}/view_templates"
    @renderBreadcrumb()

    super()

  renderViewTemplates: =>
    @collection.each (viewTemplate) =>
      view = new ViewTemplateRow model: viewTemplate, design: @model
      @$('table.view-templates tbody').append view.render().el

  addNewTemplate: =>
    @redirectTo "designs/#{@model.id}/view_templates/new"

# Local view that renders a view template within the view templates table
class ViewTemplateRow extends App.Backbone.BaseView

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
    @redirectTo "designs/#{@design.get 'id'}/view_templates/#{@model.get 'id'}"

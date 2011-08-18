class App.Views.Designs.ViewTemplateForm extends App.Backbone.ContentView

  events:
    'submit form': 'saveViewTemplate'

  initialize: (options) ->
    @preloadTemplate 'view_templates/form'
    @design = options.design

    @model.bind 'change', @render
    @design.bind 'change', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @design
      section: 'view-templates'
    
    # Render the template
    @renderTemplate 'view_templates/form', @model.toJSON()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @design.get('name'), "designs/#{@design.get 'id'}"
    @addBreadcrumb 'View templates', "designs/#{@model.get 'id'}/view_templates"
    if @model.isNew()
      @addBreadcrumb 'Add new view template', "designs/#{@design.get 'id'}/view_templates/new"
    else
      @addBreadcrumb @model.get('filename'), "designs/#{@design.get 'id'}/view_templates/#{@model.get 'id'}"
    @renderBreadcrumb()

    # Configure Ace
    @configureAceEditor @$('#view_template_markup')[0], 'html',
      showGutter: true
      onChange: (value) =>
        @model.set markup: value,
          silent: true

    # Bind the model to the form
    @bindModels()

    super()

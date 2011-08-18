class App.Views.Designs.IncludeTemplateForm extends App.Backbone.ContentView

  events:
    'submit form': 'saveIncludeTemplate'

  initialize: (options) ->
    @preloadTemplate 'include_templates/form'
    @design = options.design

    @model.bind 'change', @render
    @design.bind 'change', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @design
      section: 'include-templates'
    
    # Render the template
    @renderTemplate 'include_templates/form', @model.toJSON()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @design.get('name'), "designs/#{@design.get 'id'}"
    @addBreadcrumb 'Include templates', "designs/#{@model.get 'id'}/include_templates"
    if @model.isNew()
      @addBreadcrumb 'Add new include template', "designs/#{@design.get 'id'}/include_templates/new"
    else
      @addBreadcrumb @model.get('filename'), "designs/#{@design.get 'id'}/include_templates/#{@model.get 'id'}"
    @renderBreadcrumb()

    # Configure Ace
    @configureAceEditor @$('#include_template_markup')[0], 'html',
      showGutter: true
      onChange: (value) =>
        @model.set markup: value,
          silent: true

    # Bind the model to the form
    @bindModels()

    super()

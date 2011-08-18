class App.Views.Designs.StylesheetForm extends App.Backbone.ContentView

  events:
    'submit form': 'saveStylesheet'

  initialize: (options) ->
    @preloadTemplate 'stylesheets/form'
    @design = options.design

    @model.bind 'change', @render
    @design.bind 'change', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @design
      section: 'stylesheets'
    
    # Render the template
    @renderTemplate 'stylesheets/form', @model.toJSON()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @design.get('name'), "designs/#{@design.get 'id'}"
    @addBreadcrumb 'Stylesheets', "designs/#{@model.get 'id'}/stylesheets"
    if @model.isNew()
      @addBreadcrumb 'Add new stylesheet', "designs/#{@design.get 'id'}/stylesheets/new"
    else
      @addBreadcrumb @model.get('filename'), "designs/#{@design.get 'id'}/stylesheets/#{@model.get 'id'}"
    @renderBreadcrumb()

    # Configure Ace
    @configureAceEditor @$('#stylesheet_data')[0], 'css',
      showGutter: true
      onChange: (value) =>
        @model.set data: value,
          silent: true

    # Bind the model to the form
    @bindModels()

    super()

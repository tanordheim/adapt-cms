class App.Views.Designs.JavascriptForm extends App.Backbone.ContentView

  events:
    'submit form': 'saveJavascript'

  initialize: (options) ->
    @preloadTemplate 'javascripts/form'
    @design = options.design

    @model.bind 'change', @render
    @design.bind 'change', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @design
      section: 'javascripts'
    
    # Render the template
    @renderTemplate 'javascripts/form', @model.toJSON()

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @design.get('name'), "designs/#{@design.get 'id'}"
    @addBreadcrumb 'Javascripts', "designs/#{@model.get 'id'}/javascripts"
    if @model.isNew()
      @addBreadcrumb 'Add new javascript', "designs/#{@design.get 'id'}/javascripts/new"
    else
      @addBreadcrumb @model.get('filename'), "designs/#{@design.get 'id'}/javascripts/#{@model.get 'id'}"
    @renderBreadcrumb()

    # Configure Ace
    @configureAceEditor @$('#javascript_data')[0], 'javascript',
      showGutter: true
      onChange: (value) =>
        @model.set data: value,
          silent: true

    # Bind the model to the form
    @bindModels()

    super()

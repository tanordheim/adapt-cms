class App.Views.Designs.Form extends App.Backbone.ContentView

  events:
    'submit form': 'saveDesign'

  initialize: ->
    @preloadTemplate 'designs/form'
    @model.bind 'change', @render

  render: =>

    # Render the view.
    @renderTemplate 'designs/form', @model.toJSON()

    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage designs', 'designs'
    if @model.isNew()
      @addBreadcrumb 'Add new design', 'designs/new'
    else
      @addBreadcrumb @model.get('name'), "designs/#{@model.get 'id'}"
    @renderBreadcrumb()

    # Configure Ace
    @configureAceEditor @$('#design_markup')[0], 'html',
      showGutter: true
      onChange: (value) =>
        @model.set markup: value,
          silent: true

    # Bind the model to the form
    @bindModels()

    super()

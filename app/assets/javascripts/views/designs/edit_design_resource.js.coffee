class App.Views.Designs.EditDesignResource extends App.Backbone.ContentView

  initialize: (options) ->
    @preloadTemplate 'design_resources/edit'
    @design = options.design

    @model.bind 'change', @render
    @design.bind 'change', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @design
      section: 'resources'
    
    # Render the template
    @renderTemplate 'design_resources/edit', @model.toJSON(), {image: @model.isImage()}
    
    # Configure the uploader
    new AdaptFileUploader
      element: @$('#design-resource-uploader')[0]
      uploadLabel: 'Update file'
      single: true
      multiple: false
      action: "/api/v1/designs/#{@design.get 'id'}/resources/#{@model.get 'id'}"
      params:
        _field_name: 'file'
      onComplete: (id, filename, responseJSON) =>
        @showNotice 'The resource was successfully updated'
        @model.fetch()
    
    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @design.get('name'), "designs/#{@design.get 'id'}"
    @addBreadcrumb 'Resources', "designs/#{@design.get 'id'}/resources"
    @addBreadcrumb @model.get('filename'), "designs/#{@design.get 'id'}/resources/#{@model.get 'id'}"
    @renderBreadcrumb()
    
    super()

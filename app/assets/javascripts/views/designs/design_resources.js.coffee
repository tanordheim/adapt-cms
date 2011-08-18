class App.Views.Designs.DesignResources extends App.Backbone.ContentView

  uploadQueue: []
  uploadBatch: []
  
  initialize: (options) ->
    @preloadTemplate 'design_resources/overview'
    @design = options.design

    @model.bind 'change', @render
    @collection.bind 'reset', @render

  render: =>

    @triggerUIEvent 'design', 'design_changed',
      design: @model
      section: 'resources'

    # Render the template
    @renderTemplate 'design_resources/overview'
    @renderResources()
    
    # Configure the uploader
    new AdaptFileUploader
      element: @$('#design-resource-uploader')[0]
      uploadLabel: 'Upload files'
      multiple: true
      action: "/api/v1/designs/#{@model.get 'id'}/resources"
      params:
        _field_name: 'file'
      onSubmit: (id, filename) =>
        @addUploadQueue(id)
      onComplete: (id, filename, responseJSON) =>
        @removeUploadQueue(id)
      onCancel: (id, filename) =>
        @removeUploadQueue(id)

    # Set the breadcrumb for this view
    @addBreadcrumb 'Manage designs', 'designs'
    @addBreadcrumb @model.get('name'), "designs/#{@model.get 'id'}"
    @addBreadcrumb 'Resources', "designs/#{@model.get 'id'}/resources"
    @renderBreadcrumb()

    super()

  renderResources: =>
    @collection.each (resource) =>
      view = new DesignResourceView model: resource, design: @model
      @$('#resources').append view.render().el

  # Add an upload to our internal queue.
  addUploadQueue: (id) =>
    @uploadQueue.push id
    @uploadBatch.push id

  # Remove an upload from our internal queue, and - if we have 0 items left in
  # the queue after removing - refresh the design resources collection.
  removeUploadQueue: (id) =>
    @uploadQueue = _.reject @uploadQueue, (uploadId) =>
      uploadId == id

    if @uploadQueue.length == 0
      @uploadCompleted()

  # Callback function that gets called whenever a batch of files have completed
  # uploading. This reloads the resource index from the server and adds a
  # notice to the view.
  uploadCompleted: =>

    # Reload the resources
    @collection.fetch()

    # Show a notice
    if @uploadBatch.length == 1
      App.Data.UIState.setNotice 'The resource was successfully uploaded'
    else
      App.Data.UIState.setNotice 'The resources were successfully uploaded'

    @uploadBatch = []

# Local view that renders a design within the design resource list.
class DesignResourceView extends App.Views.Resources.Resource

  design: null

  initialize: (options) ->
    @design = options.design
    super()

  showResource: =>
    @redirectTo "designs/#{@design.get 'id'}/resources/#{@model.get 'id'}"

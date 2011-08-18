class App.Views.Resources.Navigator extends App.Views.NavigatorBaseView

  currentResource: null
  uploadQueue: []
  uploadBatch: []

  initialize: ->
    @preloadTemplate 'resources/navigator'

    # Bind to the resource changed event so we can re-render ourselves
    @bindUIEvent 'content', 'resource_changed', @changeResource

    super 'resources'
    @render()

  changeResource: (id) =>
    @currentResource = id
    @render()

  render: =>

    @renderTemplate 'resources/navigator'

    container = @$('#resource-uploader')
    if container.length > 0

      baseOptions =
        element: container[0]
        params:
          _field_name: 'file'
        onSubmit: (id, filename) =>
          @addUploadQueue(id)
        onComplete: (id, filename, responseJSON) =>
          @removeUploadQueue(id)
        onCancel: (id, filename) =>
          @removeUploadQueue(id)

      # If we're editing something, only allow a single file as an update to the
      # current resource.
      if @currentResource?
        _.extend baseOptions,
          uploadLabel: 'Update file'
          action: "/api/v1/resources/#{@currentResource}"
          single: true

      else
        _.extend baseOptions,
          uploadLabel: 'Upload files'
          action: '/api/v1/resources'
          multiple: true
        
      # Build the uploader based on our options
      fileUploader = new AdaptFileUploader baseOptions

  # Add an upload to our internal queue.
  addUploadQueue: (id) =>
    @uploadQueue.push id
    @uploadBatch.push id

  # Remove an upload from our internal queue, and - if we have 0 items left in
  # the queue after removing - refresh the resources collection.
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
    App.Data.Resources.fetch()

    # Show a notice
    if @uploadBatch.length == 1
      App.Data.UIState.setNotice 'The resource was successfully uploaded'
    else
      App.Data.UIState.setNotice 'The resources were successfully uploaded'

    @uploadBatch = []

    # If we have a resource set, then fire a reload event to make the view
    # reload.
    if @currentResource?
      @triggerUIEvent 'resources', 'resource_updated'

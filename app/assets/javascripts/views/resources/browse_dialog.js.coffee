class App.Views.Resources.BrowseDialog extends App.Backbone.BaseView

  resourceSelectedCallback: null

  initialize: (options) ->
    @resourceSelectedCallback = options.selectedCallback

    @preloadTemplate 'resources/browse_dialog'
    App.Data.Resources.bind 'reset', @render

  render: =>
    @renderTemplate 'resources/browse_dialog'
    @renderResources()

    # Enable the file uploader
    container = @$('#resource-uploader')
    if container.length > 0
      fileUploader = new AdaptFileUploader
        element: container[0]
        params:
          _field_name: 'file'
        uploadLabel: 'Upload files'
        action: '/api/v1/resources'
        multiple: true
        onComplete: (id, filename, responseJSON) ->
          App.Data.Resources.fetch()

    @

  # Render all available resources.
  renderResources: =>
    App.Data.Resources.each (resource) =>
      view = new DialogResource model: resource, selectedCallback: @resourceSelectedCallback
      @$('#resources').append(view.render().el)

# Local view that overrides the default resource view in order to properly
# collect the callback after clicking on a resource.
class DialogResource extends App.Views.Resources.Resource

  resourceSelectedCallback: null
  
  initialize: (options) ->
    @resourceSelectedCallback = options.selectedCallback
    super(options)

  showResource: =>
    @hideDialog()
    if @resourceSelectedCallback?
      @resourceSelectedCallback @model

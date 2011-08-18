class App.Views.Resources.Resource extends App.Backbone.BaseView

  tagName: 'li'

  events:
    'click': 'showResource'

  render: =>

    # Add the filename
    filename = $('<span class="filename"/>')
    filename.text @truncatedResourceName()
    $(@el).append filename

    # Add the file size
    size = $('<span/>')
    size.text App.Helpers.numberToHumanSize @model.get('file_size')
    $(@el).append size

    # Style the element
    $(@el).addClass @resourceCssClass()

    @

  # Returns a truncated resource name. This is done here since Firefox doesn't
  # support text-truncate: ellipsis yet, so we hard-truncate the string for now.
  truncatedResourceName: =>
    filename = @model.get 'filename'
    max_width = 20

    if filename.length > (max_width + 3)
      filename = filename.substring(0, max_width) + '...'

    filename

  # Returns the appropriate class for this resource based on the file extension.
  resourceCssClass: =>

    filename = @model.get 'filename'

    # If this filename doesn't contain a dot, don't add a class.
    if filename.indexOf('.') == -1
      return null

    extension = _.last filename.split('.')
    "#{extension}-resource"

  # Show details about a resource.
  showResource: =>
    @redirectTo "resources/#{@model.get 'id'}"

window.AdaptFileUploader = (o) ->

  # Update the options before passing them into the FileUploader.
  uploadLabel = o.uploadLabel || 'Upload'
  o = _.extend o,
    template: '<div class="qq-uploader">' +
                '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' +
                '<div class="qq-upload-button">' + uploadLabel + '</div>' +
                '<ul class="qq-upload-list"></ul>' +
              '</div>'

  # Call the parent constructor.
  qq.FileUploader.apply(@, arguments)

# The Adapt File Uploader inherits from FileUploader.
qq.extend window.AdaptFileUploader.prototype, qq.FileUploader.prototype

# Extend the file uploader with our changes.
qq.extend window.AdaptFileUploader.prototype,

  _onComplete: (id, fileName, result) ->

    # Set the success value based on if the result had an id or not so that the
    # FileUploader we're inheriting can do its work.
    result['success'] = result.id
    qq.FileUploader.prototype._onComplete.apply(@, arguments)

  _setupDragDrop: ->

    # If we have the single flag set, don't allow drag and drop.
    if @_options.single
      dropArea = @_find(@_element, 'drop')
      $(dropArea).remove()
    else
      qq.FileUploader.prototype._setupDragDrop.apply(@, arguments)

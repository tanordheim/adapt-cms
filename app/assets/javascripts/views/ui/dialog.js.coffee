class App.Views.UI.Dialog extends App.Backbone.BaseView

  el: '#dialog-ui'
  currentDialog: null

  events:
    'click #dialog header a': 'hideDialog'

  initialize: ->
    @bindUIEvent 'dialog', 'show', @showDialog
    @bindUIEvent 'dialog', 'hide', @hideDialog

  showDialog: (data) =>
    name = data.name
    view = data.view

    # Remove the current dialog reference if it exists.
    if @currentDialog?
      @currentDialog.remove()

    @currentDialog = view

    @$('#dialog header h2').text name
    @$('#dialog article').empty().append @currentDialog.render().el

    # Show and center the dialog
    $(@el).show()
    @$('#dialog').position
      my: 'center top'
      at: 'center top'
      of: $(@el)
      offset: '0 100px'

  hideDialog: =>
    $(@el).hide()

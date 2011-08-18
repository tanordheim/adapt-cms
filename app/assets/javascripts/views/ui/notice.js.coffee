class App.Views.UI.Notice extends App.Backbone.BaseView

  el: '#notice'

  initialize: ->
    _.bindAll @, 'render'
    @model.bind 'change:notice', @render

  render: =>
    if @model.get('notice') != ''

      # Set the notice text.
      $(@el).text @model.get('notice')

      # Show and center the message.
      $(@el).fadeIn 200
      $(@el).position
        my: 'center top'
        at: 'center top'
        of: $('#breadcrumb')
        offset: '0 13px'

      # Hide the message after 5 seconds.
      $(@el).delay(5000).fadeOut(100)


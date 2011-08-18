class App.Views.Resources.ShowDialog extends App.Backbone.BaseView

  initialize: ->
    @preloadTemplate 'resources/show_dialog'
    
  render: =>

    # Render the view
    @renderTemplate 'resources/show_dialog', @model.toJSON(), {image: @model.isImage()}

class App.Views.UI.Breadcrumb extends App.Backbone.BaseView

  el: '#breadcrumb'

  initialize: ->
    @collection.bind 'reset', @render

  render: =>
    @$('ul li').remove()
    @collection.each(@renderBreadcrumbItem)
    @

  renderBreadcrumbItem: (breadcrumb) =>
    view = new BreadcrumbItemView model: breadcrumb
    @$('ul').append(view.render().el)

# Local class used for rendering each item within the breadcrumb.
class BreadcrumbItemView extends App.Backbone.BaseView

  tagName: 'li'

  events:
    'click a': 'navigate'

  render: ->
    link = $('<a/>')
    link.text @model.get 'label'
    $(@el).append(link)
    @

  navigate: ->
    @redirectTo @model.get('path')

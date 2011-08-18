class App.Routers.ResourcesRouter extends App.Backbone.BaseRouter

  routes:
    'resources': 'overview'
    'resources/:id': 'editResource'

  #
  # Before filter-implementation. Invoked before every action of this router.
  #
  before: ->

    # Set the current section.
    App.Data.UIState.setSection 'resources'

  #
  # Display the resource overview.
  #
  overview: ->
    view = new App.Views.Resources.Overview collection: App.Data.Resources
    view.render()

  #
  # Edit a resource.
  #
  editResource: (id) ->
    resource = new App.Models.Resource id: id
    view = new App.Views.Resources.Edit model: resource
    resource.fetch()

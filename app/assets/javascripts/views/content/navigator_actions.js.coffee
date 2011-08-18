class App.Views.Content.NavigatorActions extends App.Views.NavigatorActionsBaseView

  initialize: ->
    super 'content'
    @render()

  render: =>
    addView = new AddNodeActionView
    $(@el).append addView.render().el
    @

#
# This is a local class that defines an add link for the navigator action view.
#
class AddNodeActionView extends App.Backbone.BaseView

  tagName: 'li'

  events:
    'click a': 'addNewNode'

  currentParent: null

  initialize: ->
    _.bindAll @, 'render'
    @bindUIEvent 'content', 'node_changed', @setCurrentParent

  # Render the add new node-action
  render: =>
    link = $('<a/>')
    link.text 'Add new node'
    $(@el).append link
    $(@el).addClass 'add'

    @

  # Set the currently viewed parent node.
  setCurrentParent: (nodePath) =>
    @currentParent = _.last nodePath

  addNewNode: =>
    dialogView = new NodeTypeSelectorView parentNode: @currentParent
    @showDialog 'Add new content', dialogView

#
# This is a local view that presents the user with a choice of what node type
# they wish to create.
#
class NodeTypeSelectorView extends App.Backbone.BaseView

  parentNode: null

  events:
    'click li.page a': 'addNewPage'
    'click li.blog a': 'addNewBlog'
    'click li.link a': 'addNewLink'

  initialize: (options) ->
    @preloadTemplate 'nodes/type-selector'
    @parentNode = options.parentNode

  render: =>
    @renderTemplate 'nodes/type-selector'

  redirectToNew: (nodeType) ->
    @hideDialog()
    if @parentNode?
      @redirectTo "content/#{nodeType}/new/#{@parentNode}"
    else
      @redirectTo "content/#{nodeType}/new"

  addNewPage: =>
    @redirectToNew 'pages'

  addNewBlog: =>
    @redirectToNew 'blogs'

  addNewLink: =>
    @redirectToNew 'links'

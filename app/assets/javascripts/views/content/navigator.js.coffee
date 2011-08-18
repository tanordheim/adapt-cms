class App.Views.Content.Navigator extends App.Views.NavigatorBaseView

  selectedPath: []

  initialize: ->
    super 'content'
    @collection.bind 'reset', @render
    @bindUIEvent 'content', 'node_changed', @setSelectedNodePath
    @bindUIEvent 'content', 'node_sorted', @nodeSorted

  render: =>
    @collection.each @renderNavigationItem
    $(@el).sortable
      update: (event, ui) =>
        @triggerUIEvent 'content', 'node_sorted',
          event: event,
          ui: ui
    
    @triggerUIEvent 'content', 'refreshNavigationState', @selectedPath
    @

  renderNavigationItem: (node) =>
    view = new NodeNavigationItemView model: node, collection: @collection
    $(@el).append view.render().el

  setSelectedNodePath: (nodePath) =>
    if ! _.isEqual @selectedPath, nodePath
      @selectedPath = nodePath
      @triggerUIEvent 'content', 'refreshNavigationState', @selectedPath

  nodeSorted: (data) =>
    container = $(data.event.target)
    item = $(data.ui.item)
    position = $('li', container).index(item)

    $.ajax
      url: "/api/v1/nodes/#{item.attr('data-id')}/position/#{position}"
      dataType: 'json'
      type: 'POST'
      success: =>
        # Fetch the node collection again, that should make the trees re-render
        @collection.fetch()

#
# This is a local class that defines the view for a node navigation item.
#
class NodeNavigationItemView extends App.Backbone.BaseView

  tagName: 'li'

  events:
    'click a:first': 'navigateToNode'

  initialize: ->
    _.bindAll @, 'render', 'remove'

    # Whenever the model we're binding to changes, we just re-render ourselves.
    @model.bind 'change', @render
    
    # Whenever the collection we'rebinding to resets, remove this element from
    # the view. A reset listener on the parent view will make sure to render new
    # ones.
    @collection.bind 'reset', @remove

    # Whenever the UI event content:refreshNavigationState is triggered, we
    # update our selected status.
    @bindUIEvent 'content', 'refreshNavigationState', @refreshState

  render: =>
    link = $('<a/>')
    link.text @model.get('name')
    $(@el).append link

    # Append the ID of the node to this element so we can figure out if this is
    # a sibling of the current element when toggling selected status.
    $(@el).attr 'data-id', @model.get('id')

    # If this node has children, append the branch class to the element and
    # render a new list with all the children.
    if @model.hasChildren()
      $(@el).addClass 'branch'
      $(@el).append('<ul/>')
      @model.get('children').each @renderNavigationChild
      @$('>ul').sortable
        update: (event, ui) =>
          @triggerUIEvent 'content', 'node_sorted',
            event: event,
            ui: ui

    @

  renderNavigationChild: (childNode) =>
    view = new NodeNavigationItemView model: childNode, collection: @collection
    $('> ul', $(@el)).append view.render().el

  navigateToNode: =>
    @triggerUIEvent 'content', 'node_changed', @model.ancestorIdsAndSelf()
    @redirectTo "content/#{@model.pluralizedClassification()}/#{@model.get 'id'}"

  refreshState: (nodePath) =>

    # Reset any state in this element before processing.
    $(@el).removeClass 'selected'
    $(@el).removeClass 'active'
    $(@el).removeClass 'outside-of-scope'

    # If this node doesn't have a parent node, its probably about to be removed
    # due to a reset event, so don't do anything.
    if $(@el).parent().length == 0
      return

    if nodePath.length > 0

      # Something is selected, check if its us.

      # Iterate through the node path and see if any of the the node IDs matches
      # ourselves. If it does, set the element as selected.
      #
      # However, if one of the node IDs are found as a sibling of ourself, then
      # we need to flag ourselves as outside of scope to hide ourselves.

      for nodeId in nodePath

        if nodeId == @model.get('id') # Are we a selected node?

          $(@el).addClass 'selected'

          # Are we _the_ selected node?
          if _.last(nodePath) == @model.get('id')
            $(@el).addClass 'active'

        else if $(@el).siblings("[data-id=#{nodeId}]").length > 0 # Are we a sibling of a selected node?

          # We only flag ourselves as outside of scope if the selected node
          # actually has any children.
          unless $('ul', $(@el).siblings("[data-id=#{nodeId}]")).length == 0
            $(@el).addClass 'outside-of-scope'

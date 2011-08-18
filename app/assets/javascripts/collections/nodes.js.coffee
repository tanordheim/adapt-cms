class App.Collections.Nodes extends App.Backbone.BaseCollection

  url: '/api/v1/nodes'
  model: App.Models.Node

  # Flatten the node tree and return it as a flat array of node models.
  flatten: ->
    result = []
    @each (node) ->
      result.push node
      if node.get('children')? && node.get('children').length > 0
        result.push node.get('children').flatten()
    _.flatten(result)

  # Find a node in the tree based on its id.
  findInTree: (id) ->

    # Flatten the collection tree and pick the node out from the array.
    nodeList = @flatten()
    result = _.select nodeList, (node) =>
      node.get('id') == parseInt(id)

    if result.length == 0 then null else result[0]

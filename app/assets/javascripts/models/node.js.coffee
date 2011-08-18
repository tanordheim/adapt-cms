class App.Models.Node extends App.Backbone.BaseModel

  # Defines some node defaults.
  defaults:
    published: true
    show_in_navigation: true

  initialize: ->

    # If we have an array of children, convert them to a node collection.
    if Array.isArray @get('children')
      @set children: new App.Collections.Nodes(@get('children'))

      # Add a parent reference to each node
      @get('children').each (childNode) =>
        childNode.set parent: @

  # Override the default set method to support data.* attributes.
  set: (attributes, options) ->

    # Go through the attribute object and extract any data attribute and set
    # them manually.
    dataAttributes = _.select _.keys(attributes), (attribute) ->
      attribute.substr(0, 5) == 'data.'

    for dataAttribute in dataAttributes
      key = dataAttribute.substr(5)
      @data()[key] = attributes[dataAttribute]

      # Remove this attribute from the attribute map so it doesn't get handled
      # by the super method as well.
      delete attributes[dataAttribute]
      
      unless options?.silent?
        @change(dataAttribute)

    super(attributes, options)

  # Returns true if this node has any children.
  hasChildren: =>
    @get('children')? && @get('children').length > 0

  # Returns the pluralized classification string for this node.
  pluralizedClassification: =>
    pluralized = null
    if @get('classification')?
      pluralized = "#{@get 'classification'}s"

    pluralized

  # Returns an array of ancestors for this node, starting at the top.
  ancestors: =>

    # If the node has a parents array defined, base the ancestors on that.
    if Array.isArray @get('parents')
      return _.map @get('parents'), (node) ->
        {id: node['id'], name: node['name'], classification: node['classification']}

    # If the node has a parent defined, iterate through the parent tree and
    # gather data on the way.
    if @get('parent')?
      results = []
      parent = @get('parent')
      while parent?
        results.push {id: parent.get('id'), name: parent.get('name'), classification: parent.get('classification')}
        parent = parent.get('parent')
      return results.reverse()

    # Fallback, unable to find any ancestors so we just return an empty list.
    []
  
  # Returns an array of ancestors for this node, starting at the top. Also adds
  # ourselves to the end of the list.
  ancestorsAndSelf: =>
    models = @ancestors()
    models.push {id: @get('id'), name: @get('name'), classification: @get('classification')}
    models

  # Returns an array of ancestor IDs for this node, starting at the top.
  ancestorIds: =>
    _.pluck @ancestors(), 'id'

  # Returns an array of ancestor IDS for this node, starting at the top. Also
  # add our own ID to the end of the list
  ancestorIdsAndSelf: =>
    _.pluck @ancestorsAndSelf(), 'id'

  # Returns the direct parent of this node, if any.
  parent: =>

    # If the node has a parents collection defined, pick the last item in the
    # collection as the parent.
    if Array.isArray(@get('parents')) && @get('parents').length > 0
      return new App.Models.Node _.last(@get('parents'))

    # If the node has a parent defined, return that.
    if @get('parent')?
      return @get('parent')

    # Fallback, unable to find a parent so we just return null.
    null

  # Returns the data hash for this node, if any. If no data has could be found,
  # one is created on the node and returned.
  data: =>
    if !@get('data')?
      @set data: {}
    @get 'data'

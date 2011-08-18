class App.Views.Content.Form extends App.Backbone.ContentView

  # Defines the ID of the template to render with. This must be specified by any
  # inheriting view.
  templateId: ''

  # Defines the label of the "new" element in the breadcrumb when creating a new
  # node.
  newBreadcrumbLabel: 'New'

  # Defines a function that returns the variant collection for this view. This
  # must be overridden by any inheriting view.
  variants: ->
    null

  # Defines the message to display when a save is successful.
  saveSuccessfulMessage: ''

  # Holds a reference to all field views generated for variant fields.
  variantFieldViews: []

  # Holds a reference to the parent node of the current node, if we are creating
  # a new node.
  parentNode: null

  # Wether or not we need to redirect to the node after saving.
  redirectAfterSave: false

  # Callbacks
  events:
    'submit form': 'saveModel'
    'change [data-field]': 'setDataValue'

  # Initialize the view.
  initialize: =>

    @preloadTemplate @templateId

    # Assign a reference to our parent node to use when creating new nodes.
    @assignParentReference()

    # Re-render the form if the variants change or the model we're associated
    # with changes.
    @model.bind 'change', @render
    @variants().bind 'reset', @render
    App.Data.Nodes.bind 'reset', @assignParentReference
    App.Data.Resources.bind 'reset', @render

  # Assign the parent node reference. This is called during initialize, and
  # whenever the Node collection resets.
  assignParentReference: =>
    if @model.isNew() && @model.get('parent_id')?
      @parentNode = App.Data.Nodes.findInTree @model.get('parent_id')

  # Render the view.
  render: =>

    # Reset any node navigation state we might have.
    if @model.isNew() && @parentNode?
      @triggerUIEvent 'content', 'node_changed', @parentNode.ancestorIdsAndSelf()
    else
      @triggerUIEvent 'content', 'node_changed', @model.ancestorIdsAndSelf()

    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage content', 'content'

    if @model.isNew()
      if @parentNode?
        _.each @parentNode.ancestorsAndSelf(), (parent) =>
          @addBreadcrumb parent['name'], "content/#{parent['classification']}s/#{parent['id']}"
        @addBreadcrumb @newBreadcrumbLabel, "content/#{@model.pluralizedClassification()}/new/#{@parentNode.get 'id'}"
      else
        @addBreadcrumb @newBreadcrumbLabel, "content/#{@model.pluralizedClassification()}/new"
      
    else
      _.each @model.ancestors(), (parent) =>
        @addBreadcrumb parent['name'], "content/#{parent['classification']}s/#{parent['id']}"
      @addBreadcrumb @model.get('name'), "content/#{@model.pluralizedClassification()}/#{@model.get 'id'}"

    @renderBreadcrumb()

    # Add the template to the DOM.
    @renderTemplate @templateId, @model.toJSON(), { parent: @parentJSON(), variants: @variants().toJSON() }

    # Add the variant fields to the DOM.
    @renderVariantFields()

    # Call the post render hook if any views for specific types of node forms
    # need to do something.
    @postRenderHook()

    # Assign the data values to the form
    @assignDataValues()

    # Enable model binding.
    @bindModels()

    # Call render in the ContentView parent.
    super()

  # Post render hook. Overridden by subclassed if they need to implement
  # something here.
  postRenderHook: =>

  # Save the model. This is called whever the form is submitted.
  saveModel: =>
    needRedirect = @model.isNew()
    @model.save {}, success: =>

      # Show a notice indicating the save was successful.
      @showNotice @saveSuccessfulMessage

      # Reload the node tree to update any navigation menus.
      App.Data.Nodes.fetch()

      # If we need to redirect to this node, do that.
      if needRedirect || @redirectAfterSave?
        @redirectTo @showPath()

    # Return false to avoid the form actually doing any POSTs or similar.
    false

  # Returns the show-path for this node
  showPath: =>
    "content/#{@model.pluralizedClassification()}/#{@model.get 'id'}"

  # Returns the JSON data structure for the parent node of the current node. If
  # the current node doesn't have a parent, an empty hash is returned.
  parentJSON: =>
    if @model.isNew()
      if @parentNode?
        @parentNode.toJSON()
      else
        {}
    else
      if @model.parent()?
        @model.parent().toJSON()
      else
        {}

  # Remove this view from the DOM. This also removes any variant field views we
  # might be holding from the dom before removing itself.
  remove: =>
    _.each @variantFieldViews, (view) ->
      view.remove()
    super()

  # Configure the editors for this view, if any.
  configureEditors: =>

    formView = @
    editorSelector = @$('#variant-fields .text-field textarea[data-field]')
    @configureMarkItUpEditor editorSelector

  # Render the variant fields for this node into the node form.
  renderVariantFields: =>

    # If we have any variant field views already, remove them from the DOM.
    if @variantFieldViews.length > 0
      _.each @variantFieldViews, (view) ->
        view.remove()
      @variantFieldViews = []

    # Add a view for each field found in the variant.
    variant = @variants().get @model.get('variant_id')
    if variant?
      variant.get('fields').each (field) =>

        currentValue = @model.data()[field.get('key')]

        switch field.get('classification')
          when 'check_box_field' then view = new CheckBoxFieldView model: @model, field: field, currentValue: currentValue
          when 'form_reference_field' then view = new FormReferenceFieldView model: @model, field: field, currentValue: currentValue
          # when 'radio_field' then view = new RadioFieldView model: @model, field: field, currentValue: currentValue
          when 'resource_reference_field' then view = new ResourceReferenceFieldView model: @model, field: field, currentValue: currentValue
          when 'select_field' then view = new SelectFieldView model: @model, field: field, currentValue: currentValue
          when 'string_field' then view = new StringFieldView model: @model, field: field, currentValue: currentValue
          when 'text_field' then view = new TextFieldView model: @model, field: field, currentValue: currentValue
          else view = null
          
        if view?
          @$('#variant-fields').append(view.render().el)
          @variantFieldViews.push view

    @configureEditors()

  # Assign data values to the form from the model data hash.
  assignDataValues: =>

    variant = @variants().get @model.get('variant_id')
    if variant?
      variant.get('fields').each (field) =>

        key = field.get 'key'
        type = field.get 'classification'
        fieldSelector = @$("[data-field='#{key}']")
        value = @model.data()[key] || ''

        switch type
          when 'check_box_field'
            if parseInt(value) > 0
              fieldSelector.attr('checked', 'checked')
            else
              fieldSelector.removeAttr('checked')
          else
            fieldSelector.val value

  # Set a data value in the model data hash from a form field.
  setDataValue: (e) =>
    element = $(e.target)
    key = element.attr('data-field')
    value = element.val()
    @model.data()[key] = value

#
# Base class for all variant field views
#
class VariantFieldView extends App.Backbone.BaseView

  tagName: 'li'

  initialize: (options) ->
    @field = options.field
    @currentValue = options.currentValue

  # Returns the default label for this field.
  defaultLabel: =>
    label = $('<label/>')
    label.text @field.get('name')
    label.attr('for', @fieldId())
    label

  # Returns the ID of the variant field.
  fieldId: (appendValue) =>
    id = "data_#{@field.get 'key'}"
    if appendValue?
      id = "#{id}_#{appendValue}"

    "#{id}_field"

  # Returns the name of the variant field.
  fieldName: =>
    "data.#{@field.get 'key'}"

#
# Check box variant field view
#
class CheckBoxFieldView extends VariantFieldView

  className: 'check-box-field'

  render: =>
    # Add the field
    field = $('<input/>')
    field.attr('type', 'checkbox')
    field.attr('id', @fieldId())
    field.attr('name', @fieldId())
    field.attr('data-field', @field.get('key'))
    field.attr('value', '1')
    $(@el).append field
    
    # Add the label
    $(@el).append @defaultLabel()

    @
    
#
# Radio variant field view
#
# class RadioFieldView extends VariantFieldView
# 
#   className: 'radio-field'
# 
#   render: =>
# 
#     # Add the label
#     label = $('<label/>')
#     label.text @field.get('name')
#     label.attr('for', @fieldId())
#     $(@el).append label
# 
#     # Add a field for each of the options
#     _.each @model.get('options'), (option) =>
# 
#       # Add the actual radio field.
#       field = $('<input/>')
#       field.attr('type', 'radio')
#       field.attr('id', @fieldId(@field.get 'id'))
#       field.attr('name', @fieldId())
#       field.attr('data-field', @field.get('key'))
#       field.attr('value', option)
# 
#       # Add a label for the field.
#       fieldLabel = $('<label/>')
#       fieldLabel.text option
#       fieldLabel.attr('for', @fieldId(@field.get 'id'))
# 
#       # Wrap the elements in a container
#       container = $('<div/>')
#       container.append field
#       container.append fieldLabel
# 
#       $(@el).append container
# 
#     @

#
# Resource reference variant field view
#
class ResourceReferenceFieldView extends VariantFieldView

  className: 'resource-reference-field'
  currentResource: null

  events:
    'click .browse': 'openBrowser'
    'click .current-value a': 'showResource'
    'click .remove': 'unsetValue'

  initialize: (options) ->
    super(options)
    @currentResource = App.Data.Resources.get @currentValue

  render: =>

    # Add the label
    $(@el).append @defaultLabel()

    # Add the hidden input field
    field = $('<input/>')
    field.attr('type', 'hidden')
    field.attr('id', @fieldId())
    field.attr('name', @fieldId())
    field.attr('data-field', @field.get('key'))
    $(@el).append(field)

    # Add the current value label for the field
    currentValue = $('<span/>')
    if @currentResource?
      link = $('<a/>')
      link.text @currentResource.get 'filename'
      currentValue.append link
    else
      currentValue.text 'No resource selected'
    currentValue.addClass 'current-value'
    $(@el).append(currentValue)

    # Add a "browse"-link
    browseLink = $('<a/>')
    browseLink.addClass 'browse'
    browseLink.text 'Browse'
    $(@el).append(browseLink)

    # Add a "remove" link
    removeLink = $('<a/>')
    removeLink.addClass 'remove'
    removeLink.text 'Remove'
    $(@el).append(removeLink)

    # Add the has-resource value if a resource is actually assigned to this
    # field.
    if @currentResource?
      $(@el).addClass 'has-resource'

    @

  # Show the currently selected resource.
  showResource: =>
    dialogView = new App.Views.Resources.ShowDialog model: @currentResource
    @showDialog @currentResource.get('filename'), dialogView

  # Open the resource browser to find a resource we can add to the field.
  openBrowser: =>
    dialogView = new App.Views.Resources.BrowseDialog selectedCallback: @resourceSelected
    @showDialog 'Browse for resource', dialogView

  # Callback fired from the resource browser when the user selects a resource
  resourceSelected: (resource) =>
    key = @field.get 'key'
    @model.data()[key] = resource.get 'id'
    @model.change()

  # Unset the value of this resource. This changes the value of the model to
  # null and fires a change event on the model itself.
  unsetValue: =>
    key = @field.get 'key'
    @model.data()[key] = null
    @model.change()

#
# Form reference variant field view
#
class FormReferenceFieldView extends VariantFieldView

  className: 'form-reference-field'

  initialize: (options) ->
    super(options)
    App.Data.Forms.bind 'reset', @render

  render: =>

    # Add the label
    $(@el).append @defaultLabel()

    # Add the select field
    field = $('<select/>')
    field.attr('id', @fieldId())
    field.attr('name', @fieldId())
    field.attr('data-field', @field.get('key'))

    # Add an empty option
    field.append $('<option>No form</option>')

    # Add the forms
    App.Data.Forms.each (form) ->
      optionField = $('<option/>')
      optionField.val form.get('id')
      optionField.text form.get('name')
      field.append optionField

    $(@el).append field

    @

#
# Select variant field view
#
class SelectFieldView extends VariantFieldView

  className: 'select-field'

  render: =>
    # Add the label
    $(@el).append @defaultLabel()

    # Add the select field
    field = $('<select/>')
    field.attr('id', @fieldId())
    field.attr('name', @fieldId())
    field.attr('data-field', @field.get('key'))

    # Add an empty option
    field.append $('<option>No form</option>')

    # Add the defined options
    _.each @model.get('options'), (option) ->
      optionField = $('<option/>')
      optionField.val option
      optionField.text option
      field.append optionField

    $(@el).append field

    @

#
# Text variant field view
#
class TextFieldView extends VariantFieldView

  className: 'text-field'

  render: =>

    # Add the label
    $(@el).append @defaultLabel()

    # Add the field
    field = $('<textarea/>')
    field.attr 'id', @fieldId()
    field.attr 'name', @fieldName()
    field.attr 'data-field', @field.get('key')
    field.text @currentValue
    $(@el).append field

    @

#
# String variant field view
#
class StringFieldView extends VariantFieldView

  className: 'string-field'

  render: =>

    # Add the label
    $(@el).append @defaultLabel()

    # Add the field
    field = $('<input/>')
    field.attr('type', 'text')
    field.attr('id', @fieldId())
    field.attr('name', @fieldId())
    field.attr('data-field', @field.get('key'))
    $(@el).append field

    @

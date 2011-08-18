class App.Views.Designs.Navigator extends App.Views.NavigatorBaseView

  currentDesign: null
  currentSection: null

  initialize: ->

    # Bind to the design changed event so we can update the navigation.
    @bindUIEvent 'design', 'design_changed', @changeDesign

    # Bind to the design collection reset so we can re-render ourselves.
    @collection.bind 'reset', @render

    super 'designs'
    @render()

  changeDesign: (designInfo) =>
    if designInfo?
      @currentDesign = designInfo.design
      @currentSection = designInfo.section
    else
      @currentDesign = null
      @currentSection = null

    @triggerUIEvent 'design', 'refreshNavigationState',
      design: @currentDesign,
      section: @currentSection

  render: =>
    App.Data.Designs.each @renderDesign
    @triggerUIEvent 'design', 'refreshNavigationState',
      design: @currentDesign,
      section: @currentSection
    @

  renderDesign: (design) =>
    view = new DesignItemView model: design, collection: @collection
    $(@el).append view.render().el

# This is a local view that renders a design in the design navigator.
class DesignItemView extends App.Backbone.BaseView

  tagName: 'li'
  className: 'branch'

  events:
    'click a:first': 'showDesign'
    'click .view-templates a': 'showViewTemplates'
    'click .include-templates a': 'showIncludeTemplates'
    'click .resources a': 'showResources'
    'click .javascripts a': 'showJavascripts'
    'click .stylesheets a': 'showStylesheets'

  initialize: ->

    _.bindAll @, 'render', 'remove'

    # Whenever the model we're binding to changes, just re-render ourselves
    @model.bind 'change', @render

    # Whenever the collection we're bindin to resets, remove the element from
    # the view. The listener on the parent view will make sure to render new
    # design item views.
    @collection.bind 'reset', @remove

    # Bind to the design changed event so we can refresh our current state.
    @bindUIEvent 'design', 'refreshNavigationState', @refreshState

  render: =>

    link = $('<a/>')
    link.text @model.get('name')
    $(@el).append link

    #
    # Build the sub menu of all the design navigations
    #
    designNav = $('<ul/>')

    # View templates
    viewTemplatesContainer = $('<li class="view-templates"/>')
    viewTemplates = $('<a/>')
    viewTemplates.text 'View templates'
    viewTemplatesContainer.append viewTemplates
    designNav.append viewTemplatesContainer

    # Include templates
    includeTemplatesContainer = $('<li class="include-templates"/>')
    includeTemplates = $('<a/>')
    includeTemplates.text 'Include templates'
    includeTemplatesContainer.append includeTemplates
    designNav.append includeTemplatesContainer

    # Resources
    resourcesContainer = $('<li class="resources"/>')
    resources = $('<a/>')
    resources.text 'Resources'
    resourcesContainer.append resources
    designNav.append resourcesContainer

    # Javascripts
    javascriptsContainer = $('<li class="javascripts"/>')
    javascripts = $('<a/>')
    javascripts.text 'Javascripts'
    javascriptsContainer.append javascripts
    designNav.append javascriptsContainer

    # Stylesheets
    stylesheetsContainer = $('<li class="stylesheets"/>')
    stylesheets = $('<a/>')
    stylesheets.text 'Stylesheets'
    stylesheetsContainer.append stylesheets
    designNav.append stylesheetsContainer

    $(@el).append(designNav)

    @

  refreshState: (designInfo) =>

    currentDesign = designInfo.design
    currentSection = designInfo.section

    # Reset any state before processing.
    $(@el).removeClass 'selected'
    $(@el).removeClass 'active'
    $(@el).removeClass 'outside-of-scope'

    # Remove all state from child elements as well
    @$('ul li').removeClass 'selected'
    @$('ul li').removeClass 'active'

    # If this element doesn't have a parent element, its probably about to be
    # removed due to a reset event, so don't do anything.
    if $(@el).parent().length == 0
      return

    if currentDesign?

      if currentDesign.get('id') == @model.get('id') # Are we the current design?

        $(@el).addClass 'selected'

        # If we have a section specified as current, activate that. Otherwise,
        # set the current design as the active element.
        if currentSection?
          @$(".#{currentSection}").addClass 'selected'
          @$(".#{currentSection}").addClass 'active'
        else
          $(@el).addClass 'active'

      else # We hide ourselves if something is selected and its not us.
        $(@el).addClass 'outside-of-scope'

  showDesign: =>
    @redirectTo "designs/#{@model.get 'id'}"

  showViewTemplates: =>
    @redirectTo "designs/#{@model.get 'id'}/view_templates"

  showIncludeTemplates: =>
    @redirectTo "designs/#{@model.get 'id'}/include_templates"

  showResources: =>
    @redirectTo "designs/#{@model.get 'id'}/resources"

  showJavascripts: =>
    @redirectTo "designs/#{@model.get 'id'}/javascripts"

  showStylesheets: =>
    @redirectTo "designs/#{@model.get 'id'}/stylesheets"

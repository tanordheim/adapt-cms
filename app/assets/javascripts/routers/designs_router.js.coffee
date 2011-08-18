class App.Routers.DesignsRouter extends App.Backbone.BaseRouter

  routes:
    'designs': 'overview'
    'designs/:design_id/view_templates': 'showViewTemplates'
    'designs/:design_id/view_templates/new': 'newViewTemplate'
    'designs/:design_id/view_templates/:id': 'editViewTemplate'
    'designs/:design_id/include_templates': 'showIncludeTemplates'
    'designs/:design_id/include_templates/new': 'newIncludeTemplate'
    'designs/:design_id/include_templates/:id': 'editIncludeTemplate'
    'designs/:design_id/resources': 'showResources'
    'designs/:design_id/resources/:id': 'editResource'
    'designs/:design_id/javascripts': 'showJavascripts'
    'designs/:design_id/javascripts/new': 'newJavascript'
    'designs/:design_id/javascripts/:id': 'editJavascript'
    'designs/:design_id/stylesheets': 'showStylesheets'
    'designs/:design_id/stylesheets/new': 'newStylesheet'
    'designs/:design_id/stylesheets/:id': 'editStylesheet'
    'designs/new': 'newDesign'
    'designs/:id': 'showDesign'

  #
  # Before filter-implementation. Invoked before every action of this router.
  #
  before: ->

    # Set the current section.
    App.Data.UIState.setSection 'designs'

  #
  # Display the design overview page.
  #
  overview: ->
    view = new App.Views.Designs.Overview collection: App.Data.Designs
    view.render()

  #
  # Display the form to create a new design.
  #
  newDesign: ->

    design = new App.Models.Design
    view = new App.Views.Designs.New model: design
    view.render()

  #
  # Display a specific design from the design list.
  #
  showDesign: (id) ->
    design = new App.Models.Design id: id
    view = new App.Views.Designs.Edit model: design
    design.fetch()

  #
  # List all view templates for a design.
  #
  showViewTemplates: (designId) ->
    templates = new App.Collections.ViewTemplates designId
    design = new App.Models.Design id: designId
    view = new App.Views.Designs.ViewTemplates model: design, collection: templates
    templates.fetch()
    design.fetch()

  #
  # Create a new view template for a design.
  #
  newViewTemplate: (designId) ->
    design = new App.Models.Design id: designId
    template = new App.Models.ViewTemplate design_id: designId
    view = new App.Views.Designs.NewViewTemplate model: template, design: design
    design.fetch()

  #
  # Edit a view template for a design.
  #
  editViewTemplate: (designId, id) ->
    design = new App.Models.Design id: designId
    template = new App.Models.ViewTemplate id: id, design_id: designId
    view = new App.Views.Designs.EditViewTemplate model: template, design: design
    template.fetch()
    design.fetch()

  #
  # List all include templates for a design.
  #
  showIncludeTemplates: (designId) ->
    templates = new App.Collections.IncludeTemplates designId
    design = new App.Models.Design id: designId
    view = new App.Views.Designs.IncludeTemplates model: design, collection: templates
    templates.fetch()
    design.fetch()

  #
  # Create a new include template for a design.
  #
  newIncludeTemplate: (designId) ->
    design = new App.Models.Design id: designId
    template = new App.Models.IncludeTemplate design_id: designId
    view = new App.Views.Designs.NewIncludeTemplate model: template, design: design
    design.fetch()

  #
  # Edit a include template for a design.
  #
  editIncludeTemplate: (designId, id) ->
    design = new App.Models.Design id: designId
    template = new App.Models.IncludeTemplate id: id, design_id: designId
    view = new App.Views.Designs.EditIncludeTemplate model: template, design: design
    template.fetch()
    design.fetch()

  #
  # List all resources for a design.
  #
  showResources: (designId) ->
    resources = new App.Collections.DesignResources designId
    design = new App.Models.Design id: designId
    view = new App.Views.Designs.DesignResources model: design, collection: resources
    resources.fetch()
    design.fetch()

  #
  # Edit a design resource for a design.
  #
  editResource: (designId, id) ->
    design = new App.Models.Design id: designId
    resource = new App.Models.DesignResource id: id, design_id: designId
    view = new App.Views.Designs.EditDesignResource model: resource, design: design
    resource.fetch()
    design.fetch()

  #
  # List all javascripts for a design.
  #
  showJavascripts: (designId) ->
    javascripts = new App.Collections.Javascripts designId
    design = new App.Models.Design id: designId
    view = new App.Views.Designs.Javascripts model: design, collection: javascripts
    javascripts.fetch()
    design.fetch()

  #
  # Create a new javascript for a design.
  #
  newJavascript: (designId) ->
    design = new App.Models.Design id: designId
    javascript = new App.Models.Javascript design_id: designId
    view = new App.Views.Designs.NewJavascript model: javascript, design: design
    design.fetch()

  #
  # Edit a javascript for a design.
  #
  editJavascript: (designId, id) ->
    design = new App.Models.Design id: designId
    javascript = new App.Models.Javascript id: id, design_id: designId
    view = new App.Views.Designs.EditJavascript model: javascript, design: design
    javascript.fetch()
    design.fetch()

  #
  # List all stylesheets for a design.
  #
  showStylesheets: (designId) ->
    stylesheets = new App.Collections.Stylesheets designId
    design = new App.Models.Design id: designId
    view = new App.Views.Designs.Stylesheets model: design, collection: stylesheets
    stylesheets.fetch()
    design.fetch()

  #
  # Create a new stylesheet for a design.
  #
  newStylesheet: (designId) ->
    design = new App.Models.Design id: designId
    stylesheet = new App.Models.Stylesheet design_id: designId
    view = new App.Views.Designs.NewStylesheet model: stylesheet, design: design
    design.fetch()

  #
  # Edit a stylesheet for a design.
  #
  editStylesheet: (designId, id) ->
    design = new App.Models.Design id: designId
    stylesheet = new App.Models.Stylesheet id: id, design_id: designId
    view = new App.Views.Designs.EditStylesheet model: stylesheet, design: design
    stylesheet.fetch()
    design.fetch()

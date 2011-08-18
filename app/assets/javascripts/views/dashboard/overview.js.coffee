class App.Views.Dashboard.Overview extends App.Backbone.ContentView

  initialize: ->
    @preloadTemplate 'dashboard/overview'
    @collection.bind 'reset', @render

  render: =>

    # Render the breadcrumb
    @addBreadcrumb 'Dashboard', 'dashboard'
    @renderBreadcrumb()

    # Render the page template
    @renderTemplate 'dashboard/overview'

    # Render the activities
    @collection.each @renderActivity

    super()

  renderActivity: (activity) =>
    view = new ActivityView model: activity
    @$('.recent-activities tbody').append view.render().el

# Local view used to render an activity in the activity list.
class ActivityView extends App.Backbone.BaseView

  tagName: 'tr'

  events:
    'click a.activity-source': 'showSource'

  render: =>

    # Add the description column
    description = $('<td class="description"/>')

    html = @sourceTypeName()
    html += " <a class=\"activity-source\">#{@model.get('source_name')}</a>"

    count = @model.get('count')
    action = @model.get('action')
    if action == 'create'
      html += " was created by"
    else if action == 'update'
      if count == 1
        html += " was updated by"
      else
        html += " was updated #{count} times by"

    html += " <a class=\"activity-author\">#{@model.get('author_name')}</a>"

    description.html html
    $(@el).append description

    # Add the time column
    time = $('<td class="time"/>')
    time.text App.Helpers.formatTimestamp(@model.get 'updated_at')
    $(@el).append time

    @

  showSource: =>
    @redirectTo @model.sourceUrl()

  # Returns the name of the source type for this model
  sourceTypeName: =>
    switch @model.get('source_type')
      when 'Node' then 'The node'
      when 'Page' then 'The page'
      when 'Link' then 'The link'
      when 'Blog' then 'The blog'
      when 'BlogPost' then 'The blog post'
      when 'Resource' then 'The resource'

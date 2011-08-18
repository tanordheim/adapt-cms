class App.Models.Activity extends App.Backbone.BaseModel

  # Returns the URL for this resource
  url: =>
    @apiPath 'activities'

  # Returns the URL to the source in this activity.
  sourceUrl: =>
    switch @get('source_type')
      when 'Page' then prefix = 'pages'
      when 'Link' then prefix = 'links'
      when 'Blog' then prefix = 'blogs'
      when 'BlogPost' then prefix = "blogs/#{@get 'parent_id'}/posts"
      else prefix = ''

    "content/#{prefix}/#{@get 'id'}"

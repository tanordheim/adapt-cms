class App.Models.Blog extends App.Models.Node

  # Define some blog defaults.
  defaults:
    published: true
    show_in_navigation: true
    classification: 'blog'

  # Returns the URL for this blog.
  url: =>
    if @isNew()
      @apiPath 'blogs'
    else
      @apiPath "blogs/#{@get 'id'}"

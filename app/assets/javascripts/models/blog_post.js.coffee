class App.Models.BlogPost extends App.Models.Node

  # Define some blog post defaults.
  defaults:
    published: true
    published_on: new Date().strftime('%Y-%m-%d')
    show_in_navigation: true
    classification: 'blog_post'

  # Returns the URL for this blog post.
  url: =>
    if @isNew()
      @apiPath "blogs/#{@get 'parent_id'}/posts"
    else
      @apiPath "blogs/#{@get 'parent_id'}/posts/#{@get 'id'}"

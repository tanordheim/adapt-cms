class App.Collections.BlogPosts extends App.Backbone.BaseCollection

  model: App.Models.BlogPost
  blogId: null

  # Initialize the collection with a blog id.
  initialize: (blogId) =>
    @blogId = blogId

  # Returns the URL for this collection.
  url: =>
    "/api/v1/blogs/#{@blogId}/posts"

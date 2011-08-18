class App.Routers.ContentRouter extends App.Backbone.BaseRouter

  routes:
    'content': 'overview',
    'content/pages/new/:parentId': 'newPage'
    'content/pages/new': 'newPage'
    'content/pages/:id': 'showPage'
    'content/blogs/new/:parentId': 'newBlog'
    'content/blogs/new': 'newBlog'
    'content/blogs/:parentId/posts/new': 'newBlogPost'
    'content/blogs/:parentId/posts/:id': 'showBlogPost'
    'content/blogs/:id/edit': 'editBlog'
    'content/blogs/:id': 'showBlog'
    'content/links/new/:parentId': 'newLink'
    'content/links/new': 'newLink'
    'content/links/:id': 'showLink'

  #
  # Before filter-implementation. Invoked before every action of this router.
  #
  before: ->

    # Set the current section.
    App.Data.UIState.setSection 'content'

  #
  # Display the content overview page.
  #
  overview: ->
    new App.Views.Content.Overview

  #
  # Display the form to create a new page.
  #
  newPage: (parentId) ->

    page = new App.Models.Page parent_id: parentId
    view = new App.Views.Content.NewPage model: page
    view.render()

  #
  # Display a specific page from the node tree.
  #
  showPage: (id) ->
    page = new App.Models.Page id: id
    view = new App.Views.Content.EditPage model: page
    page.fetch()

  #
  # Display the form to create a new blog.
  #
  newBlog: (parentId) ->

    blog = new App.Models.Blog parent_id: parentId
    view = new App.Views.Content.NewBlog model: blog
    view.render()

  #
  # Edit a specific blog from the node tree.
  #
  editBlog: (id) ->
    blog = new App.Models.Blog id: id
    view = new App.Views.Content.EditBlog model: blog
    blog.fetch()

  #
  # Display a specific blog from the node tree.
  #
  showBlog: (id) ->
    blog = new App.Models.Blog id: id
    collection = new App.Collections.BlogPosts id
    view = new App.Views.Content.ShowBlog model: blog, collection: collection
    blog.fetch()
    collection.fetch()

  #
  # Display the form to create a new blog post.
  #
  newBlogPost: (parentId) ->

    blogPost = new App.Models.BlogPost parent_id: parentId
    view = new App.Views.Content.NewBlogPost model: blogPost
    view.render()

  #
  # Display a specific blog post from the node tree.
  #
  showBlogPost: (parentId, id) ->
    blogPost = new App.Models.BlogPost id: id, parent_id: parentId
    view = new App.Views.Content.EditBlogPost model: blogPost
    blogPost.fetch()

  #
  # Display the form to create a new link.
  #
  newLink: (parentId) ->

    link = new App.Models.Link parent_id: parentId
    view = new App.Views.Content.NewLink model: link
    view.render()

  #
  # Display a specific link from the node tree.
  #
  showLink: (id) ->
    link = new App.Models.Link id: id
    view = new App.Views.Content.EditLink model: link
    link.fetch()

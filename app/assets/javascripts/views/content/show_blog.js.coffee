class App.Views.Content.ShowBlog extends App.Backbone.ContentView

  events:
    'click #content-actions .edit a': 'editBlog'
    'click #content-actions .new-post a': 'newPost'

  # Initialize the view.
  initialize: =>
    @preloadTemplate 'blogs/show'

    # Re-render the page if the blog or the collection we're associated
    # with changes.
    @model.bind 'change', @render
    @collection.bind 'reset', @render

  # Render the view.
  render: =>

    # Set the breadcrumb for this view.
    @addBreadcrumb 'Manage content', 'content'
    _.each @model.ancestors(), (parent) =>
      @addBreadcrumb parent['name'], "content/#{parent['classification']}s/#{parent['id']}"
    @addBreadcrumb @model.get('name'), "content/#{@model.pluralizedClassification()}/#{@model.get 'id'}"
    @renderBreadcrumb()

    # Render the template to the DOM.
    @renderTemplate 'blogs/show', @model.toJSON()
    
    # Render the posts to the DOM.
    @renderPosts()
    
    # Call the render in the ContentView parent.
    super()

  # Edit this blog.
  editBlog: =>
    @redirectTo "content/blogs/#{@model.get 'id'}/edit"

  # Make a new post for this blog.
  newPost: =>
    @redirectTo "content/blogs/#{@model.get 'id'}/posts/new"

  # Render all the posts for this blog.
  renderPosts: =>
    @collection.each (post) =>
      view = new BlogPostRow model: post, blog: @model
      @$('table.blog-posts tbody').append view.render().el

# Local view that renders a blog post within the blog post table
class BlogPostRow extends App.Backbone.BaseView
  
  tagName: 'tr'
  blog: null

  events:
    'click a': 'showPost'

  initialize: (options) =>
    @blog = options.blog

  render: =>

    # Build the title column
    title = $('<td class="title"/>')
    link = $('<a/>')
    link.text @model.get('name')
    title.append link
    $(@el).append title

    # Build the created at column
    created = $('<td class="published-on"/>')
    created.text App.Helpers.formatDate(@model.get('published_on'))
    $(@el).append created

    @

  showPost: =>
    @redirectTo "content/blogs/#{@blog.get 'id'}/posts/#{@model.get 'id'}"

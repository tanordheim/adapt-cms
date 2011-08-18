class App.Views.Content.NewBlogPost extends App.Views.Content.Form

  templateId: 'blog_posts/form'
  newBreadcrumbLabel: 'Add new blog post'
  saveSuccessfulMessage: 'The blog post was successfully created'

  variants: =>
    App.Data.BlogPostVariants

  showPath: =>
    "content/blogs/#{@model.get 'parent_id'}/posts/#{@model.get 'id'}"

  postRenderHook: =>
    @$('#blog_post_published_on').datepicker
      dateFormat: 'yy-mm-dd'

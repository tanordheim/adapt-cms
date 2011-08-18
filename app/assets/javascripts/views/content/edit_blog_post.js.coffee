class App.Views.Content.EditBlogPost extends App.Views.Content.Form

  templateId: 'blog_posts/form'
  saveSuccessfulMessage: 'The blog post was successfully updated'

  variants: =>
    App.Data.BlogPostVariants

  postRenderHook: =>
    @$('#blog_post_published_on').datepicker
      dateFormat: 'yy-mm-dd'

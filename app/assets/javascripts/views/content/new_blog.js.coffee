class App.Views.Content.NewBlog extends App.Views.Content.Form

  templateId: 'blogs/form'
  newBreadcrumbLabel: 'Add new blog'
  saveSuccessfulMessage: 'The blog was successfully created'

  variants: =>
    App.Data.BlogVariants

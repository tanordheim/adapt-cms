class App.Views.Content.EditBlog extends App.Views.Content.Form

  templateId: 'blogs/form'
  saveSuccessfulMessage: 'The blog was successfully updated'
  redirectAfterSave: true

  variants: =>
    App.Data.BlogVariants

class App.Views.Content.EditLink extends App.Views.Content.Form

  templateId: 'links/form'
  saveSuccessfulMessage: 'The link was successfully updated'

  variants: =>
    App.Data.LinkVariants

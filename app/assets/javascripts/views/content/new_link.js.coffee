class App.Views.Content.NewLink extends App.Views.Content.Form

  templateId: 'links/form'
  newBreadcrumbLabel: 'Add new link'
  saveSuccessfulMessage: 'The link was successfully created'

  variants: =>
    App.Data.LinkVariants

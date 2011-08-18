class App.Views.Content.NewPage extends App.Views.Content.Form

  templateId: 'pages/form'
  newBreadcrumbLabel: 'Add new page'
  saveSuccessfulMessage: 'The page was successfully created'

  variants: =>
    App.Data.PageVariants

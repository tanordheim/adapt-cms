class App.Views.Content.EditPage extends App.Views.Content.Form

  templateId: 'pages/form'
  saveSuccessfulMessage: 'The page was successfully updated'

  variants: =>
    App.Data.PageVariants

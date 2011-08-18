class App.Views.Designs.EditViewTemplate extends App.Views.Designs.ViewTemplateForm

  saveViewTemplate: =>
    @model.save {}, success: =>
      @showNotice 'The view template was successfully updated'

    false

class App.Views.Designs.EditIncludeTemplate extends App.Views.Designs.IncludeTemplateForm

  saveIncludeTemplate: =>
    @model.save {}, success: =>
      @showNotice 'The include template was successfully updated'

    false

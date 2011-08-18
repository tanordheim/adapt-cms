class App.Views.Designs.NewIncludeTemplate extends App.Views.Designs.IncludeTemplateForm

  saveIncludeTemplate: =>
    @model.save {}, success: =>

      @showNotice 'The include template was successfully created'
      @redirectTo "designs/#{@design.get 'id'}/include_templates/#{@model.get 'id'}"

    false

class App.Views.Designs.NewViewTemplate extends App.Views.Designs.ViewTemplateForm

  saveViewTemplate: =>
    @model.save {}, success: =>

      @showNotice 'The view template was successfully created'
      @redirectTo "designs/#{@design.get 'id'}/view_templates/#{@model.get 'id'}"

    false

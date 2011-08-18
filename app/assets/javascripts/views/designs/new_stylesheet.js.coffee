class App.Views.Designs.NewStylesheet extends App.Views.Designs.StylesheetForm

  saveStylesheet: =>
    @model.save {}, success: =>

      @showNotice 'The stylesheet was successfully created'
      @redirectTo "designs/#{@design.get 'id'}/stylesheets/#{@model.get 'id'}"

    false

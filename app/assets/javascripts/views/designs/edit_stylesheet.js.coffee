class App.Views.Designs.EditStylesheet extends App.Views.Designs.StylesheetForm

  saveStylesheet: =>
    @model.save {}, success: =>
      @showNotice 'The stylesheet was successfully updated'

    false

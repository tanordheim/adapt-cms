class App.Views.Designs.EditJavascript extends App.Views.Designs.JavascriptForm

  saveJavascript: =>
    @model.save {}, success: =>
      @showNotice 'The javascript was successfully updated'

    false

class App.Views.Designs.NewJavascript extends App.Views.Designs.JavascriptForm

  saveJavascript: =>
    @model.save {}, success: =>

      @showNotice 'The javascript was successfully created'
      @redirectTo "designs/#{@design.get 'id'}/javascripts/#{@model.get 'id'}"

    false

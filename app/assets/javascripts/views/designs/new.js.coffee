class App.Views.Designs.New extends App.Views.Designs.Form

  render: =>
    @triggerUIEvent 'design', 'design_changed', null
    super()

  # Create the design.
  saveDesign: =>
    @model.save {}, success: =>

      @showNotice 'The design was successfully created'

      App.Data.Designs.fetch()
      @redirectTo "designs/#{@model.get 'id'}"

    false

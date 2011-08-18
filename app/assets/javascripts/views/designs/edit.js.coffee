class App.Views.Designs.Edit extends App.Views.Designs.Form

  render: =>
    @triggerUIEvent 'design', 'design_changed', { design: @model }
    super()

  # Update the design.
  saveDesign: =>
    @model.save {}, success: =>

      @showNotice 'The design was successfully updated'
      App.Data.Designs.fetch()

    false

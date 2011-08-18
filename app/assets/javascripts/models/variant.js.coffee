class App.Models.Variant extends App.Backbone.BaseModel

  initialize: ->

    # If we havean array of fields, convert them into a variant fields
    # collection.
    if Array.isArray @get('fields')
      @set fields: new App.Collections.VariantFields(@get('fields'))
    else
      @set fields: new App.Collections.VariantFields

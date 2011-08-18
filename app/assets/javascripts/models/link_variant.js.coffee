class App.Models.LinkVariant extends App.Models.Variant

  # Returns the URL for this link variant
  url: =>
    if @isNew()
      @apiPath 'link_variants'
    else
      @apiPath "link_variants/#{@get 'id'}"

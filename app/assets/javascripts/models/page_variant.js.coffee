class App.Models.PageVariant extends App.Models.Variant

  # Returns the URL for this page variant
  url: =>
    if @isNew()
      @apiPath 'page_variants'
    else
      @apiPath "page_variants/#{@get 'id'}"

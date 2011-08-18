class App.Models.BlogVariant extends App.Models.Variant

  # Returns the URL for this blog variant
  url: =>
    if @isNew()
      @apiPath 'blog_variants'
    else
      @apiPath "blog_variants/#{@get 'id'}"

class App.Models.BlogPostVariant extends App.Models.Variant

  # Returns the URL for this blog post variant
  url: =>
    if @isNew()
      @apiPath 'blog_post_variants'
    else
      @apiPath "blog_post_variants/#{@get 'id'}"

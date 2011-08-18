class App.Models.Link extends App.Models.Node

  # Define some link defaults.
  defaults:
    published: true
    show_in_navigation: true
    classification: 'link'

  # Returns the URL for this link.
  url: =>
    if @isNew()
      @apiPath 'links'
    else
      @apiPath "links/#{@get 'id'}"

class App.Models.Page extends App.Models.Node

  # Define some page defaults.
  defaults:
    published: true
    show_in_navigation: true
    classification: 'page'

  # Returns the URL for this page.
  url: =>
    if @isNew()
      @apiPath 'pages'
    else
      @apiPath "pages/#{@get 'id'}"

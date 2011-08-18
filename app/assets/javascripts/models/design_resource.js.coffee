class App.Models.DesignResource extends App.Backbone.BaseModel

  defaults:
    filename: ''
    markup: ''

  # Returns the URL for this design resource
  url: =>
    if @isNew()
      @apiPath "designs/#{@get 'design_id'}/resources"
    else
      @apiPath "designs/#{@get 'design_id'}/resources/#{@get 'id'}"

  # Returns true if this design resource is an image.
  isImage: =>
    @get('content_type')? && @get('content_type').substring(0, 6) == 'image/'

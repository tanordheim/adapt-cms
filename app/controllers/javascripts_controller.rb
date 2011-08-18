class JavascriptsController < StaticResourceController

  expose(:javascript) { requested_javascript }

  protected

  # Load the requested javascript.
  def requested_javascript
    design = Site.current.designs.find(params[:design_id])
    javascript = design.javascripts.find_by_filename!(params[:filename])
  end
  
  # Return the compiled javascript contents.
  def resource_data
    javascript.data
  end

  # Return the content type used to serve javascripts.
  def content_type
    'text/javascript'
  end
  
end

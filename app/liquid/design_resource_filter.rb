# Design resource filter

module DesignResourceFilter

  # Returns the liquified design resource based on the input file name.
  def design_resource(input)

    design_id = @context['__design_id']
    resource = Rails.cache.fetch "design_resource_#{design_id}_#{input}" do
      DesignResource.where(:design_id => design_id).find_by_filename(input)
    end

    resource.blank? ? nil : resource.to_liquid

  end

end

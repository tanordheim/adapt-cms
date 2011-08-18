# Node filter

module NodeFilter

  # Returns the liquified node based on the input uri
  def node(input)

    site_id = @context['__site_id']
    
    # Attempt to locate the node.
    node = Rails.cache.fetch "node:#{site_id}:#{input}" do
      n = node_scope.find_by_uri(input)
      n.blank? ? nil : n.to_liquid
    end

    node

  end

  # Returns the liquified node based on the input id
  def node_from_id(input)

    site_id = @context['__site_id']
    
    # Attempt to locate the node.
    node = Rails.cache.fetch "node_id:#{site_id}:#{input}" do
      n = node_scope.where(:id => input.to_i).first
      n.blank? ? nil : n.to_liquid
    end

    node
    
  end

  private

  # Returns the scope to use when querying for nodes
  def node_scope
    scope = Node.where(:site_id => @context['__site_id'])
    scope = scope.with_attributes
    scope = scope.with_variant
    scope
  end

end

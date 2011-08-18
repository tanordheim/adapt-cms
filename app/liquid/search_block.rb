class SearchBlock < BaseBlock

  def initialize(tag_name, markup, tokens)
    @nodelist = @search_block = []
    super
  end

  # Render the search results.
  def render(context)

    search_results = fetch_search_results(context)

    result = []
    context.stack do
      search_results.each do |search_result|

        search_result.each do |key, value|
          context[key] = value
        end
        result << render_all(@search_block, context)

      end
    end

    result

  end

  private

  # Execute a Sunspot search and return the results as a collection of liquified
  # node models.
  #
  # Example query:
  # classification:blog_post parent_uri:news order_by:'published_on desc' limit:10
  def fetch_search_results(context)

    params = @params
    site_id = context['__site_id']

    matching_ids = Node.search_ids do

      # Site ID
      with :site_id, site_id

      # Node classification
      if params['classification']
        with :classification, params['classification']
      end

      # Parent
      if params['scope_to']
        parent_scope = context[params['scope_to']]
        with :parent_uri, parent_scope['uri']
      elsif params['parent_uri']
        with :parent_uri, params['parent_uri']
      end

      # Ordering
      order_by_fields = params['order_by'].blank? ? [] : params['order_by'].split(',')
      order_by_fields.each do |order_by_field|

        field_name, direction = order_by_field.gsub(/["']/, '').strip.split(' ', 2)
        direction = 'asc' if direction.blank?
        order_by field_name.to_sym, direction.to_sym

      end

      # Limit
      if params['limit']
        paginate :page => 1, :per_page => params['limit']
      end

    end

    results = []
    matching_ids.each do |id|

      node = Rails.cache.fetch "node_id:#{site_id}:#{id}" do
        Node.where(:site_id => site_id).find(id).to_liquid
      end
      results << node

    end

    results

  end

end

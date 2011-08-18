# encoding: utf-8

# Handles sweeping cache for node related data.
class NodeCacheSweeper < ActionController::Caching::Sweeper

  observe Node

  # After save-callback for nodes. Purges all related cache for the saved node.
  def after_save(node)
    sweep(node)
  end

  private

  # Sweep the cache for the specified node.
  def sweep(node)

    site_id = node.site_id
    node_id = node.id
    uri = node.uri

    # If this node is a root, sweep the root node cache. Also sweep the Liquid
    # representation of the site as it holds a reference to all root nodes.
    #
    # TODO - This is actually purging the root node cache if any of the roots
    # change, not just the actual front page. This needs optimizations.
    if node.is_root?

      Rails.logger.debug("Purging root node for site #{site_id}")
      Rails.cache.delete("node:#{site_id}:")

      Rails.logger.debug("Purting site liquid cache for site #{site_id}")
      Rails.cache.delete("site_liquid:#{site_id}")

    end
    
    # If this node is not a root, sweep the cache for the parent node as well.
    unless node.is_root?
      sweep(node.parent)
    end

    # Purge the ID cache for this node.
    Rails.logger.debug("Purging ID cache for node #{node_id} and site #{site_id}")
    Rails.cache.delete("node_id:#{site_id}:#{node_id}")

    # Purge the uri cache for this node.
    Rails.logger.debug("Purging URI cache for node #{node_id} with uri #{uri} and site #{site_id}")
    Rails.cache.delete("node:#{site_id}:#{uri}")

  end

end

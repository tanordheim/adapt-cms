class SitemapController < ApplicationController #:nodoc

  respond_to :xml
  expose(:nodes) { current_site.nodes.where(:published => true) }

  def index
    respond_with(nodes)
  end

end

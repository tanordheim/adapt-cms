# encoding: utf-8

class Blog < Node #:nodoc

  # Return the posts for this blog.
  def posts
    children.where(:type => 'BlogPost').reorder('nodes.published_on DESC, nodes.created_at DESC')
  end

end

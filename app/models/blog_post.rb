# encoding: utf-8

class BlogPost < Node #:nodoc

  # Validate that this blog post is owned by a blog.
  validate :validate_blog_post_ownership

  # Validate that the blog post has a published date set
  validates :published_on, :presence => true

  private

  # Validate that the parent model of this blog post is defined, and that its a
  # blog.
  def validate_blog_post_ownership
    if parent.blank? || !parent.is_a?(Blog)
      errors.add(:parent_id, 'must be a blog')
    end
  end

end

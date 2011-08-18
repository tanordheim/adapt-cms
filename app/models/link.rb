# encoding: utf-8

class Link < Node #:nodoc

  # Validate that the link has a href set.
  validates :href, :presence => true

  # Transform the link into a hash for use in liquid templates
  def to_liquid
    liquid = super
    liquid['href'] = self.href
    liquid
  end

end

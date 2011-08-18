# Raised when the site could not be identified based on the current request.
#
# @example Create the error.
#   InvalidSite.new(request.subdomains.first)
class InvalidSiteError < StandardError #:nodoc

  def initialize(site)
    super "Invalid site requested: #{site.to_s}"
  end

end

# Raised when an admin attempts to access a site of which he doesn't have the
# required privileges.
#
# @example Create the error.
#   NoPrivilegesError.new
class NoPrivilegesError < StandardError #:nodoc
end

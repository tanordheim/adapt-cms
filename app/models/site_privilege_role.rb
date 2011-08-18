# encoding: utf-8

class SitePrivilegeRole < ActiveRecord::Base #:nodoc

  ROLES = %W(OWNER)

  # Site privilege roles binds a role to any given site privilege.
  belongs_to :site_privilege

  # Validate that the site privilege role is associated with a site privilege.
  validates :site_privilege, :presence => true

  # Validate that the site privilege role has a role set.
  validates :role, :presence => true, :inclusion => { :in => ROLES }

end

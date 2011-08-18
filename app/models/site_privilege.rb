# encoding: utf-8

class SitePrivilege < ActiveRecord::Base #:nodoc

  # Site privileges connects a site with an administrator to grant them access.
  belongs_to :site
  belongs_to :admin

  # Site privileges can have a list of roles giving the user specific privileges
  # for the site.
  has_many :roles, :class_name => 'SitePrivilegeRole', :dependent => :destroy, :before_add => :assign_self_to_role

  # Validate that the site privilege is associated with a site.
  validates :site, :presence => true
  validates :admin, :presence => true

  private

  # Assign an instance of self to a role added to the list
  def assign_self_to_role(role)
    role.site_privilege = self
  end

end

# encoding: utf-8

class SiteHost < ActiveRecord::Base #:nodoc

  # Site hosts belong to a site, and defines the virtual hostname that any given
  # site should respond to, in addition to the default Adapt hostname.
  belongs_to :site

  # Validate that the site host has a site defined.
  validates :site, :presence => true

  # Validate that the site host has a hostname defined, and that the hostname is
  # globally unique.
  validates :hostname, :presence => true, :uniqueness => { :case_sensitive => false }

  # Before saving this site host, ensure that all other hosts are set as
  # non-primary if this host is saved as a primary.
  before_save :ensure_is_only_primary_host

  # By default, site hosts are ordered by hostname, ascending. The primary host
  # is always put first, regardless of alphabetical order.
  default_scope order('site_hosts.primary DESC').order('LOWER(site_hosts.hostname) ASC')

  # Filters the hosts which have the primary flag set to true.
  scope :primary, where(:primary => true)

  private

  # Ensure that this site host is the only primary host for the site if this
  # host has the primary flag set.
  #
  # If other hosts with the primary flag is found for this site, the primary
  # flag will be removed from all other hosts.
  def ensure_is_only_primary_host

    return true unless self.primary?

    other_hosts = SiteHost.where(:site_id => site.id).primary
    unless new_record?
      other_hosts = other_hosts.where(['site_hosts.id != ?', id])
    end

    if other_hosts.count > 0
      other_hosts.update_all(['"primary" = ?', false])
    end

    true

  end

end

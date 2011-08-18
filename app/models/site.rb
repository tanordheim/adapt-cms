# encoding: utf-8

class Site < ActiveRecord::Base #:nodoc

  # Class attribute that holds the current site loaded for a request from the
  # application controller.
  class_attribute :current

  # All available locales for a site.
  LOCALES = %w(en nb)

  # The accepted subdomain format for this site
  SUBDOMAIN_FORMAT = /^[a-z][a-z0-9-]{3,}$/

  # Validate that the site has a subdomain set, thats its globally unique, and
  # that it matches the regular expression SUBDOMAIN_FORMAT.
  #
  # @see Site::SUBDOMAIN_FORMAT for the valid subdomain format.
  validates :subdomain, :presence => true, :uniqueness => { :case_sensitive => false }, :format => { :with => SUBDOMAIN_FORMAT }

  # Validate that th site has a name set.
  validates :name, :presence => true

  # Validate the site has a locale set, and that its one of the valid,
  # registered locales.
  #
  # @see Site::LOCALES for all registered locales.
  validates :locale, :presence => true, :inclusion => { :in => LOCALES }

  # Each site can contain several host definitions describing the virtual
  # hostnames that the site should respond to.
  has_many :hosts, :class_name => 'SiteHost', :dependent => :destroy, :before_add => :assign_self_to_host

  # Each site can contain several nodes, defining the content of the site.
  has_many :nodes, :dependent => :destroy
  has_many :pages
  has_many :links
  has_many :blogs
  has_many :blog_posts

  # Each site can contain several resources, defining file-based assets
  # supplementing the content of the site.
  has_many :resources, :dependent => :destroy

  # Each site can contain several forms, defining user input forms used to
  # aquire input from a user.
  has_many :forms, :dependent => :destroy
  has_many :email_forms

  # Each site can contain several design, used to decorate the site content.
  has_many :designs, :dependent => :destroy

  # Each site can contain several variants, describing a set of custom
  # attributes on any given node type.
  has_many :variants, :dependent => :destroy

  # Each site can have several site privileges, connecting administrators to
  # this site to give them administrative access.
  has_many :site_privileges, :dependent => :destroy
  has_many :admins, :through => :site_privileges

  # Each site can have many activities, acting as a log of what actions the site
  # administrators have performed on the site content.
  has_many :activities, :dependent => :destroy

  # Returns all sites having the specified hostname. This will always return
  # just one site, inside an ActiveRecord::Relation.
  scope :by_hostname, lambda { |hostname| joins(:hosts).where(:site_hosts => { :hostname => hostname }) }

  # Adds the design data to the query, preloading the data from the database
  # when the site is loaded.
  scope :with_design_data, includes(:designs => [:view_templates, :include_templates])

  # Returns the default host to use for this site. If the site has a primary
  # hostname defined, that hostname will be returned. Otherwise, the adaptapp.com
  # hostname will be returned.
  #
  # @return [ String ] Site default host.
  def default_host
    primary_host = hosts.primary.first
    primary_host.blank? ? "#{subdomain}.adaptapp.com" : primary_host.hostname
  end

  # Returns the default design to use for this site.
  #
  # @return [ Design ] Site default design.
  def default_design
    designs.select { |d| d.default? }.first
  end

  # Returns the Liquid representation of this site.
  def to_liquid

    navigation_nodes = self.nodes.roots.visible_in_navigation.with_attributes.with_variant.sorted.all.collect(&:to_liquid)

    {
      'id' => self.id,
      'name' => self.name,
      'root' => navigation_nodes.first,
      'hostname' => self.default_host,
      'navigation' => navigation_nodes,
      'navigation_without_root' => navigation_nodes[1..-1] || []
    }
  end

  private

  # Assign a reference self to a site host added to the list.
  def assign_self_to_host(site_host)
    site_host.site = self
  end
  
end

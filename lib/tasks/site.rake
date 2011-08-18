namespace :site do

  desc "Create a new site"
  task :create, :subdomain, :name, :owner_email, :needs => :environment do |task, args|

    subdomain = args[:subdomain]
    name = args[:name]
    owner_email = args[:owner_email]

    raise ArgumentError, "Missing subdomain" if subdomain.blank?
    raise ArgumentError, "Missing site name" if name.blank?
    raise ArgumentError, "Missing owner email" if owner_email.blank?

    owner = Admin.find_by_email!(owner_email)

    puts "Creating new site '#{name}' (#{subdomain}.adaptapp.com) for owner #{owner_email}"

    site = Site.create!(:subdomain => subdomain, :name => name)
    privilege = SitePrivilege.new(:admin => owner, :site => site)
    privilege.roles.build(:role => 'OWNER')
    privilege.save!

    puts "Site created with ID #{site.id}"

  end

  desc "Add a host to a site"
  task :add_host, :subdomain, :host, :primary, :needs => :environment do |task, args|

    subdomain = args[:subdomain]
    host = args[:host]
    primary = args[:primary] && args[:primary] == 'true' ? true : false

    raise ArgumentError, "Missing subdomain" if subdomain.blank?
    raise ArgumentError, "Missing host" if host.blank?

    puts "Adding new host '#{host}' to site #{subdomain}"

    site = Site.find_by_subdomain!(subdomain)
    host = site.hosts.build(:hostname => host, :primary => primary)
    site.save!

    puts "Host added with ID #{host.id}"
    
  end

  desc "List all available sites"
  task :list => :environment do |task, args|

    sites = Site.includes(:hosts).all
    sites.each do |site|

      fields = []
      fields << site.subdomain
      fields << site.name
      fields << site.hosts.collect { |h| h.primary? ? "*#{h.hostname}*" : h.hostname }.join(',')
      fields << 'UNDER MAINTENANCE' if site.maintenance_mode?

      puts fields.join("\t")

    end

  end

  desc "List administrator privileges for a site"
  task :privileges, :subdomain, :needs => :environment do |task, args|

    subdomain = args[:subdomain]

    raise ArgumentError, "Missing subdomain" if subdomain.blank?

    site = Site.find_by_subdomain!(subdomain)
    site.site_privileges.each do |privilege|
      puts "#{privilege.admin.email}\t#{privilege.roles.collect(&:role).join(',')}"
    end

  end

  desc "Add an administrator to a site"
  task :add_privilege, :subdomain, :email, :owner, :needs => :environment do |task, args|

    subdomain = args[:subdomain]
    email = args[:email]
    owner = args[:owner] && args[:owner] == 'true' ? true : false

    raise ArgumentError, "Missing subdomain" if subdomain.blank?
    raise ArgumentError, "Missing email" if email.blank?
    
    site = Site.find_by_subdomain!(subdomain)
    admin = Admin.find_by_email!(email)

    if admin.has_privileges_for?(site)

      puts "Updating admin '#{email}' access to site #{subdomain}"
      
      p = SitePrivilege.where(:site_id => site.id).where(:admin_id => admin.id).first
      p.roles.clear
      p.roles.build(:role => 'OWNER') if owner
      p.save!

      puts "Privilege with ID #{p.id} updated"

    else

      puts "Granting admin '#{email}' access to site #{subdomain}"

      p = SitePrivilege.new(:site => site, :admin => admin)
      p.roles.build(:role => 'OWNER') if owner
      p.save!

      puts "Privilege granted with ID #{p.id}"

    end

  end

  desc "Start maintenance on a site"
  task :start_maintenance, :subdomain, :needs => :environment do |task, args|

    subdomain = args[:subdomain]

    raise ArgumentError, "Missing subdomain" if subdomain.blank?

    site = Site.find_by_subdomain!(subdomain)
    site.maintenance_mode = true
    site.save!

    puts "Started maintenance on site ID #{site.id}"

  end

  desc "Stop maintenance on a site"
  task :stop_maintenance, :subdomain, :needs => :environment do |task, args|

    subdomain = args[:subdomain]

    raise ArgumentError, "Missing subdomain" if subdomain.blank?

    site = Site.find_by_subdomain!(subdomain)
    site.maintenance_mode = false
    site.save!

    puts "Stopped maintenance on site ID #{site.id}"

  end
  
end

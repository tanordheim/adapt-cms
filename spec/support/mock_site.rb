# Mock a Site instance and assign it to Site.current
#
# @return [ Site ] The newly mocked Site instance
def mock_site

  # Build a site and add some hosts to it
  site = Fabricate.build(:site, :subdomain => 'test', :locale => 'en', :name => 'Test Site')
  site.hosts << Fabricate.build(:site_host, :site => site, :hostname => 'www1.test.com', :primary => true)
  site.hosts << Fabricate.build(:site_host, :site => site, :hostname => 'www2.test.com')
  site.save!

  # Create an administrator for the site.
  @admin = Fabricate(:admin, :name => 'Test Administrator', :email => 'test@test.com')

  # Stub the find_by_subdomain finder in Site to always return this site
  Site.stub(:find_by_subdomain).and_return(site)
  Site.stub(:by_hostname).and_return([site])

  # Authenticate the current administrator
  @request.env['devise.mapping'] = Devise.mappings[:admin]
  sign_in @admin
  
  # Assign the current site
  Site.current = site

end

# Returns the current administrator instance. This requires that a site has been
# mocked.
#
# @return [ Admin ] Current administrator instance.
def current_admin
  @admin
end

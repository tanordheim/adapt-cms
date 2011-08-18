# encoding: utf-8

# Clear the data in the database
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

# Create a site
site = Site.new(:subdomain =>  'test', :name => 'Test Site')
site.hosts.build(:hostname => 'test.127.0.0.1.nip.io')
site.hosts.build(:hostname => 'alt-test.127.0.0.1.nip.io')
site.save!

# Create an administrator with ownership of the test site.
test_admin = Admin.create!(:email => 'test@example.com', :name => 'Test Admin', :password => 'secret', :password_confirmation => 'secret')
admin_priv = SitePrivilege.new(:site => site, :admin => test_admin)
admin_priv.roles.build(:role => 'OWNER')
admin_priv.save!

# Create some variants.
static_page = Variant.new(:site => site, :name => 'Static page', :node_type => 'page')
static_page.text_fields.build(:key => 'content', :name => 'Contents')
static_page.save!

resource_page = Variant.new(:site => site, :name => 'Resource page', :node_type => 'page')
resource_page.resource_reference_fields.build(:key => 'resource', :name => 'Resource')
resource_page.save!

blog_post = Variant.new(:site => site, :name => 'Blog post', :node_type => 'blog_post')
blog_post.text_fields.build(:key => 'introduction', :name => 'Introduction')
blog_post.text_fields.build(:key => 'body', :name => 'body')
blog_post.save!

everything_page = Variant.new(:site => site, :name => 'Everything', :node_type => 'page')
everything_page.check_box_fields.build(:key => 'check_box', :name => 'CheckBoxField')
everything_page.radio_fields.build(:key => 'radio', :name => 'RadioField', :options => ['Option 1', 'Option 2'])
everything_page.resource_reference_fields.build(:key => 'resource_reference', :name => 'ResourceReferenceField')
everything_page.form_reference_fields.build(:key => 'form_reference', :name => 'FormReferenceField')
everything_page.select_fields.build(:key => 'select', :name => 'SelectField', :options => ['Option 1', 'Option 2'])
everything_page.text_fields.build(:key => 'text', :name => 'TextField')
everything_page.string_fields.build(:key => 'string', :name => 'StringField')
everything_page.save!

# Create a simple page structure for the site.
home_page = Page.create!(:site => site, :name => 'Home', :creator => test_admin, :updater => test_admin)
services_page = Page.create!(:site => site, :name => 'Services', :creator => test_admin, :updater => test_admin)
programming_services_page = Page.create!(:site => site, :parent => services_page, :name => 'Programming services', :creator => test_admin, :updater => test_admin)
programming_references_page = Page.create!(:site => site, :parent => programming_services_page, :name => 'References', :creator => test_admin, :updater => test_admin)
administrative_services_page = Page.create!(:site => site, :parent => services_page, :name => 'Administrative services', :creator => test_admin, :updater => test_admin)
blog = Blog.create!(:site => site, :name => 'Blog', :creator => test_admin, :updater => test_admin)
blog_post = BlogPost.create!(:site => site, :parent => blog, :name => 'Test Post', :published_on => Date.today, :creator => test_admin, :updater => test_admin)
contact_page = Page.create!(:site => site, :name => 'Contact us', :creator => test_admin, :updater => test_admin)

# Add a test form for the site.
form = EmailForm.create!(:site => site, :name => 'Test Form', :submit_text => 'Submit', :success_url => '/', :email_address => 'test@example.com')

# Create a design for the site.
design = Design.create!(:site => site, :name => 'Default Design', :default => true, :markup => <<-EOF
<html>
  <head>
    <title>Test Site</title>
    {{ 'screen' | stylesheet }}
    {{ 'app' | javascript }}
  </head>
  <body>

    <h1>Test Site</h1>
    <nav>
      {% navigation nodes:site.navigation %}
    </nav>

    <article>
      {{content}}
    </article>

  </body>
</html>
EOF
)

# Create a stylesheet for the design.
stylesheet = Stylesheet.create!(:design => design, :filename => 'screen', :data => <<-EOF
body {
  font-family: 'Lucida Grande', 'Gill Sans', 'Arial', 'Helvetica', sans-serif;
  font-size: 80%;
  line-height: 1.1em;
}

h1 {
  font-size: 17px;
}

nav {
  background: #f5f5f5;
  height: 20px;
  padding: 10px;
  border: 1px solid #ddd;
  margin-bottom: 10px;
}

nav ul {
  list-style: none;
  margin: 0;
  padding: 0;
}

nav ul li {
  list-style: none;
  margin: 0;
  padding: 0;
  display: inline-block;
}

nav ul li a {
  display: block;
  line-height: 20px;
}

header {
  border-bottom: 1px solid #ddd;
  margin: 0 0 10px 0;
  padding: 0 0 5px 0;
}

header  h2 {
  margin: 0;
  padding: 0;
  font-size: 14px;
}
EOF
)

# Create a javascript for the design.
javascript = Javascript.create!(:design => design, :filename => 'app', :data => <<-EOF
// Implement something.
EOF
)

# Create a basic page view-template.
page_view_template = ViewTemplate.create!(:design => design, :filename => 'page', :markup => <<-EOF
<header>
  <h2>{{page.name}}</h2>
</header>
EOF
)

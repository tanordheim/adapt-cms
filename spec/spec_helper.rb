# encoding: utf-8

require 'rubygems'
require 'spork'

Spork.prefork do

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda-matchers'
  require 'fabrication'
  require 'ffaker'
  require 'database_cleaner'
  require 'json_spec'
  require 'timecop'
  require 'support/mock_site'
  require 'support/file_upload'

  include ActionDispatch::TestProcess

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Grab the original sunspot session, as we're replacing it in a before filter
  # in the configure block.
  $original_sunspot_session = Sunspot.session

  RSpec.configure do |config|

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # Configure database cleaner
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end
    config.before(:each) do
      DatabaseCleaner.start
      Rails.cache.clear
    end
    config.after(:each) do
      DatabaseCleaner.clean
      Rails.cache.clear
    end

    # Include the Devise test helpers
    config.include Devise::TestHelpers, :type => :controller

    # Use the stub session proxy for testing.
    config.before do
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
    end
  end

  JsonSpec.configure do
    exclude_keys 'id'
  end

end

Spork.each_run do
end

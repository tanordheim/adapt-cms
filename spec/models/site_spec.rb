# encoding: utf-8

require 'spec_helper'

describe Site do

  context '#attributes' do
    it { should have_db_column(:subdomain).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:locale).of_type(:string).with_options(:null => false, :default => 'en') }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should have_many(:hosts).dependent(:destroy) }
    it { should have_many(:nodes).dependent(:destroy) }
    it { should have_many(:pages) }
    it { should have_many(:links) }
    it { should have_many(:blogs) }
    it { should have_many(:blog_posts) }
    it { should have_many(:resources).dependent(:destroy) }
    it { should have_many(:forms).dependent(:destroy) }
    it { should have_many(:email_forms) }
    it { should have_many(:designs).dependent(:destroy) }
    it { should have_many(:variants).dependent(:destroy) }
    it { should have_many(:site_privileges).dependent(:destroy) }
    it { should have_many(:admins).through(:site_privileges) }
    it { should have_many(:activities).dependent(:destroy) }
  end

  context '#validations' do
    before(:each) { Fabricate(:site) }
    it { should validate_presence_of(:subdomain) }
    it { should validate_uniqueness_of(:subdomain).case_insensitive }
    it { should validate_presence_of(:name) }

    # Subdomains must be at least 4 characters in length and start with a normal
    # character. They can not contain spaces and must contain only normal
    # characters, numbers and dashes.
    it { should allow_value('test').for(:subdomain) }
    it { should allow_value('t1234').for(:subdomain) }
    it { should allow_value('t-est').for(:subdomain) }
    it { should_not allow_value('tæst').for(:subdomain) }     # Contains an abnormal character.
    it { should_not allow_value('t est').for(:subdomain) }    # Contains a space
    it { should_not allow_value('1234').for(:subdomain) }     # Doesnt start with a normal character.
    it { should_not allow_value('t_est').for(:subdomain) }    # Contains underscore.
    it { should_not allow_value('tst').for(:subdomain) }      # Less than 4 characters.

    it { should validate_presence_of(:locale) }
    it { should allow_value('en').for(:locale) }
    it { should allow_value('nb').for(:locale) }
    it { should_not allow_value('invalid_locale').for(:locale) }
  end

  context '#default host' do
    let(:site_without_hosts) { Fabricate(:site, :subdomain => 'test') }
    let(:site_without_primary_host) do
      site = site_without_hosts
      site.hosts.build(:hostname => 'www.test.com')
      site.save
      site
    end
    let(:site_with_primary_host) do
      site = site_without_primary_host
      host = site.hosts.first
      host.primary = true
      host.save
      site.reload
      site
    end

    it 'should return the adapt host as default if there are no hosts' do
      site_without_hosts.default_host.should == 'test.adaptapp.com'
    end

    it 'should return the adapt host as default if there are no primary hosts' do
      site_without_primary_host.default_host.should == 'test.adaptapp.com'
    end

    it 'should return the primary host as default if present' do
      site_with_primary_host.default_host.should == 'www.test.com'
    end
  end

  context '#liquid' do
    let(:site) do
      site = Fabricate(:site, :name => 'Test Site', :subdomain => 'test')
      Fabricate(:page, :site => site, :name => 'Page 1')
      Fabricate(:page, :site => site, :name => 'Page 2')
      Fabricate(:page, :site => site, :name => 'Page 3', :show_in_navigation => false)
      site
    end

    let(:liquid) { site.to_liquid }

    it 'should return a hash' do
      liquid.should be_a(Hash)
    end

    it 'should contain the id' do
      liquid['id'].should == site.id
    end

    it 'should contain the name' do
      liquid['name'].should == 'Test Site'
    end

    it 'should contain the default host' do
      liquid['hostname'].should == 'test.adaptapp.com'
    end

    it 'should contain the root page' do
      liquid['root'].should be_a(Hash)
      liquid['root']['name'].should == 'Page 1'
    end

    it 'should contain the navigation elements' do
      liquid['navigation'].should be_an(Array)
      liquid['navigation'].size.should == 2
    end

    it 'should contain the navigation elements excluding the root page' do
      liquid['navigation_without_root'].should be_an(Array)
      liquid['navigation_without_root'].size.should == 1
    end
  end

end

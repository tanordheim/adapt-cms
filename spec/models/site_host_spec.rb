# encoding: utf-8

require 'spec_helper'

describe SiteHost do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:hostname).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:primary).of_type(:boolean).with_options(:null => false, :default => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
  end

  context '#validations' do
    before(:each) { Fabricate(:site_host) }
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:hostname) }
    it { should validate_uniqueness_of(:hostname).case_insensitive }
  end

  context '#primary hostname' do
    let(:site) do
      Fabricate(:site)
    end

    it 'should allow adding a primary hostname' do
      Fabricate(:site_host, :site => site, :hostname => 'www1.test.com', :primary => true)
      site.reload
      site.hosts.find_by_hostname('www1.test.com').primary.should be_true
    end

    it 'should not change the primary when saving a non-primary hostname' do
      Fabricate(:site_host, :site => site, :hostname => 'www1.test.com', :primary => true)
      Fabricate(:site_host, :site => site, :hostname => 'www2.test.com')
      site.reload
      host = site.hosts.find_by_hostname('www2.test.com')
      host.save!
      site.reload
      site.hosts.find_by_hostname('www1.test.com').primary.should be_true
    end

    it 'should allow setting an existing hostname as primary' do
      Fabricate(:site_host, :site => site, :hostname => 'www1.test.com')
      site.reload
      host = site.hosts.find_by_hostname('www1.test.com')
      host.primary = true
      host.save!
      site.reload
      site.hosts.find_by_hostname('www1.test.com').primary.should be_true
    end

    it 'should set other hostnames to non-primary when adding a new primary' do
      Fabricate(:site_host, :site => site, :hostname => 'www1.test.com', :primary => true)
      Fabricate(:site_host, :site => site, :hostname => 'www2.test.com', :primary => true)
      site.reload
      site.hosts.find_by_hostname('www1.test.com').primary.should be_false
      site.hosts.find_by_hostname('www2.test.com').primary.should be_true
    end

    it 'should set other hostnames to non-primary when setting an existing hostname as primary' do
      Fabricate(:site_host, :site => site, :hostname => 'www1.test.com', :primary => false)
      Fabricate(:site_host, :site => site, :hostname => 'www2.test.com', :primary => true)
      site.reload
      host = site.hosts.find_by_hostname('www1.test.com')
      host.primary = true
      host.save!
      site.reload
      site.hosts.find_by_hostname('www1.test.com').primary.should be_true
      site.hosts.find_by_hostname('www2.test.com').primary.should be_false
    end
  end
end

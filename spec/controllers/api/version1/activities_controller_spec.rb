# encoding: utf-8

require 'spec_helper'

describe Api::Version1::ActivitiesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/activities'}, :controller => 'api/version1/activities', :action => 'index')
  end
  
  context '#retrieving resource information' do
    before(:each) do
      mock_site
      @page1 = Fabricate(:page, :site => Site.current, :name => 'Test Page', :creator => current_admin, :updater => current_admin)
      @page2 = Fabricate(:page, :site => Site.current, :name => 'Second Test Page', :creator => current_admin, :updater => current_admin)
    end

    it 'should return activity collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"parent_id": null, "source_id": #{@page2.id}, "source_type": "Page", "source_name": "Second Test Page", "action": "create", "count": 1, "author_name": "Test Administrator", "author_email": "test@test.com"},
          {"parent_id": null, "source_id": #{@page1.id}, "source_type": "Page", "source_name": "Test Page", "action": "create", "count": 1, "author_name": "Test Administrator", "author_email": "test@test.com"}
        ]
      }).excluding('created_at').excluding('updated_at')
    end
  end
  
end

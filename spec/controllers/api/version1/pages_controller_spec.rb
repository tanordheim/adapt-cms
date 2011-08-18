# encoding: utf-8

require 'spec_helper'

describe Api::Version1::PagesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :post, :path => '/api/v1/pages'}, :controller => 'api/version1/pages', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/pages/1'}, :controller => 'api/version1/pages', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/pages/1'}, :controller => 'api/version1/pages', :action => 'update', :id => '1')
  end

  context '#retrieving page information' do
    before(:each) do
      mock_site
      @page = Fabricate(:page, :name => 'Test Page', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return page information in JSON format' do
      get :show, :id => @page.id
      json = response.body
      json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Test Page", "published": true, "show_in_navigation": true, "slug": "test_page", "uri": "test_page", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant page' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new page' do
    before(:each) do
      mock_site
    end

    context '#adding root page' do
      it 'should return 200 ok when successfully creating' do
        post :create, :name => 'Test Page'
        json = response.body
        response.response_code.should == 200
        json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Test Page", "published": true, "show_in_navigation": true, "slug": "test_page", "uri": "test_page", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
      end

      it 'should return 422 unprocessable entity when validation fails' do
        post :create, :name => ''
        json = response.body
        response.response_code.should == 422
        json.should be_json_eql(%({"name": ["can't be blank"]}))
      end
    end

    context '#adding child page' do
      before(:each) do
        @parent = Fabricate(:link, :name => 'Root', :creator => current_admin, :updater => current_admin, :site => Site.current)
      end

      it 'should return 200 ok when successfully creating' do
        post :create, :name => 'Test Page', :parent_id => @parent.id
        json = response.body
        response.response_code.should == 200
        json.should be_json_eql(%({"parents": [{"uri": "root", "name": "Root", "classification": "link"}], "variant_id": null, "name": "Test Page", "published": true, "show_in_navigation": true, "slug": "test_page", "uri": "root/test_page", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
      end
    end
  end
  
  context '#updating page' do
    before(:each) do
      mock_site
      @page = Fabricate(:page, :name => 'Test Page', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Page', :id => @page.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Updated Test Page", "published": true, "show_in_navigation": true, "slug": "test_page", "uri": "test_page", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => '', :id => @page.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant page' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end
  
end

# encoding: utf-8

require 'spec_helper'

describe Api::Version1::LinksController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :post, :path => '/api/v1/links'}, :controller => 'api/version1/links', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/links/1'}, :controller => 'api/version1/links', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/links/1'}, :controller => 'api/version1/links', :action => 'update', :id => '1')
  end

  context '#retrieving link information' do
    before(:each) do
      mock_site
      @link = Fabricate(:link, :name => 'Test Link', :href => 'http://www.test.com/', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return link information in JSON format' do
      get :show, :id => @link.id
      json = response.body
      json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Test Link", "href": "http://www.test.com/", "published": true, "show_in_navigation": true, "slug": "test_link", "uri": "test_link", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant link' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new link' do
    before(:each) do
      mock_site
    end

    context '#adding root link' do
      it 'should return 200 ok when successfully creating' do
        post :create, :name => 'Test Link', :href => 'http://www.test.com/'
        json = response.body
        response.response_code.should == 200
        json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Test Link", "href": "http://www.test.com/", "published": true, "show_in_navigation": true, "slug": "test_link", "uri": "test_link", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
      end

      it 'should return 422 unprocessable entity when validation fails' do
        post :create, :name => '', :href => 'http://www.test.com/'
        json = response.body
        response.response_code.should == 422
        json.should be_json_eql(%({"name": ["can't be blank"]}))
      end
    end

    context '#adding child link' do
      before(:each) do
        @parent = Fabricate(:page, :name => 'Root', :creator => current_admin, :updater => current_admin, :site => Site.current)
      end

      it 'should return 200 ok when successfully creating' do
        post :create, :name => 'Test Link', :href => 'http://www.test.com/', :parent_id => @parent.id
        json = response.body
        response.response_code.should == 200
        json.should be_json_eql(%({"parents": [{"uri": "root", "name": "Root", "classification": "page"}], "variant_id": null, "name": "Test Link", "href": "http://www.test.com/", "published": true, "show_in_navigation": true, "slug": "test_link", "uri": "root/test_link", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
      end
    end
  end
  
  context '#updating link' do
    before(:each) do
      mock_site
      @link = Fabricate(:link, :name => 'Test Link', :href => 'http://www.test.com/', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Link', :id => @link.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Updated Test Link", "href": "http://www.test.com/", "published": true, "show_in_navigation": true, "slug": "test_link", "uri": "test_link", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => '', :id => @link.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant link' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end
  
end

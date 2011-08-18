# encoding: utf-8

require 'spec_helper'

describe Api::Version1::BlogsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :post, :path => '/api/v1/blogs'}, :controller => 'api/version1/blogs', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/blogs/1'}, :controller => 'api/version1/blogs', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/blogs/1'}, :controller => 'api/version1/blogs', :action => 'update', :id => '1')
  end

  context '#retrieving blog information' do
    before(:each) do
      mock_site
      @blog = Fabricate(:blog, :name => 'Test Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return blog information in JSON format' do
      get :show, :id => @blog.id
      json = response.body
      json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Test Blog", "published": true, "show_in_navigation": true, "slug": "test_blog", "uri": "test_blog", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant blog' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new blog' do
    before(:each) do
      mock_site
    end

    context '#adding root blog' do
      it 'should return 200 ok when successfully creating' do
        post :create, :name => 'Test Blog'
        json = response.body
        response.response_code.should == 200
        json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Test Blog", "published": true, "show_in_navigation": true, "slug": "test_blog", "uri": "test_blog", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
      end

      it 'should return 422 unprocessable entity when validation fails' do
        post :create, :name => ''
        json = response.body
        response.response_code.should == 422
        json.should be_json_eql(%({"name": ["can't be blank"]}))
      end
    end

    context '#adding child blog' do
      before(:each) do
        @parent = Fabricate(:page, :name => 'Root', :creator => current_admin, :updater => current_admin, :site => Site.current)
      end

      it 'should return 200 ok when successfully creating' do
        post :create, :name => 'Test Blog', :parent_id => @parent.id
        json = response.body
        response.response_code.should == 200
        json.should be_json_eql(%({"parents": [{"uri": "root", "name": "Root", "classification": "page"}], "variant_id": null, "name": "Test Blog", "published": true, "show_in_navigation": true, "slug": "test_blog", "uri": "root/test_blog", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
      end
    end
  end
  
  context '#updating blog' do
    before(:each) do
      mock_site
      @blog = Fabricate(:blog, :name => 'Test Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Blog', :id => @blog.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"parents": [], "variant_id": null, "name": "Updated Test Blog", "published": true, "show_in_navigation": true, "slug": "test_blog", "uri": "test_blog", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => '', :id => @blog.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant blog' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end
  
end

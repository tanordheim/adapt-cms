# encoding: utf-8

require 'spec_helper'

describe Api::Version1::ResourcesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/resources'}, :controller => 'api/version1/resources', :action => 'index')
    assert_routing({:method => :post, :path => '/api/v1/resources'}, :controller => 'api/version1/resources', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/resources/1'}, :controller => 'api/version1/resources', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/resources/1'}, :controller => 'api/version1/resources', :action => 'update', :id => '1')
    assert_routing({:method => :delete, :path => '/api/v1/resources/1'}, :controller => 'api/version1/resources', :action => 'destroy', :id => '1')
  end
  
  context '#retrieving resource information' do
    before(:each) do
      mock_site
      @file1 = Fabricate(:resource, :file => upload_file('text_file.txt', 'text/plain'), :creator => current_admin, :updater => current_admin, :site => Site.current)
      @file2 = Fabricate(:resource, :file => upload_file('png_file.png', 'image/png'), :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return resource collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"filename": "png_file.png", "url": "/resources/#{@file2.id}/png_file.png", "content_type": "image/png", "file_size": 1677, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}},
          {"filename": "text_file.txt", "url": "/resources/#{@file1.id}/text_file.txt", "content_type": "text/plain", "file_size": 20, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return resource information in JSON format' do
      get :show, :id => @file1.id
      json = response.body
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/resources/#{@file1.id}/text_file.txt", "content_type": "text/plain", "file_size": 20, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant resource' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new resource' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully creating' do
      uploader = upload_file('text_file.txt', 'text/plain')
      post :create, :file => uploader
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/resources/#{Resource.first.id}/text_file.txt", "content_type": "text/plain", "file_size": 20, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :file => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"file": ["can't be blank"]}))
    end
  end
  
  context '#updating resource' do
    before(:each) do
      mock_site
      @file = Fabricate(:resource, :file => upload_file('text_file.txt', 'text/plain'), :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      uploader = upload_file('png_file.png', 'image/png')
      put :update, :file => uploader, :id => @file.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "png_file.png", "url": "/resources/#{@file.id}/png_file.png", "content_type": "image/png", "file_size": 1677, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 200 ok when updating without passing in a file' do
      put :update, :file => '', :id => @file.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/resources/#{@file.id}/text_file.txt", "content_type": "text/plain", "file_size": 20, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to update a non-existant resource' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#deleting resource' do
    before(:each) do
      mock_site
      @file = Fabricate(:resource, :file => upload_file('text_file.txt', 'text/plain'), :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :id => @file.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/resources/#{@file.id}/text_file.txt", "content_type": "text/plain", "file_size": 20, "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant resource' do
      delete :destroy, :id => 0
      response.response_code.should == 404
    end
  end
  
end

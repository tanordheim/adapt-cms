# encoding: utf-8

require 'spec_helper'

describe Api::Version1::DesignResourcesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/designs/1/resources'}, :controller => 'api/version1/design_resources', :action => 'index', :design_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/designs/1/resources'}, :controller => 'api/version1/design_resources', :action => 'create', :design_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/designs/1/resources/2'}, :controller => 'api/version1/design_resources', :action => 'show', :design_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/designs/1/resources/2'}, :controller => 'api/version1/design_resources', :action => 'update', :design_id => '1', :id => '2')
    assert_routing({:method => :delete, :path => '/api/v1/designs/1/resources/2'}, :controller => 'api/version1/design_resources', :action => 'destroy', :design_id => '1', :id => '2')
  end

  context '#retrieving include template information' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @file1 = Fabricate(:design_resource, :file => upload_file('text_file.txt', 'text/plain'), :design => @design)
      @file2 = Fabricate(:design_resource, :file => upload_file('png_file.png', 'image/png'), :design => @design)
      @other_design = Fabricate(:design, :site => Site.current)
      @other_design_file = Fabricate(:design_resource, :file => upload_file('text_file.txt', 'text/plain'), :design => @other_design)
    end

    it 'should return design resource collection information in JSON format' do
      get :index, :design_id => @design.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"filename": "png_file.png", "url": "/design_resources/#{@file2.id}/png_file.png", "content_type": "image/png", "file_size": 1677},
          {"filename": "text_file.txt", "url": "/design_resources/#{@file1.id}/text_file.txt", "content_type": "text/plain", "file_size": 20}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return design resource information in JSON format' do
      get :show, :design_id => @design.id, :id => @file1.id
      json = response.body
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/design_resources/#{@file1.id}/text_file.txt", "content_type": "text/plain", "file_size": 20})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when loading design resources from a non-existant design' do
      get :index, :design_id => 0
      response.response_code.should == 404
    end
  end

  context '#adding new design resource' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      uploader = upload_file('text_file.txt', 'text/plain')
      post :create, :design_id => @design.id, :file => uploader
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/design_resources/#{DesignResource.first.id}/text_file.txt", "content_type": "text/plain", "file_size": 20})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :design_id => @design.id, :file => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"file": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to create design resource under a non-existant design' do
      post :create, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#updating design resource' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @file = Fabricate(:design_resource, :file => upload_file('text_file.txt', 'text/plain'), :design => @design)
    end

    it 'should return 200 ok when successfully updating' do
      uploader = upload_file('png_file.png', 'image/png')
      put :update, :design_id => @design.id, :id => @file.id, :file => uploader
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "png_file.png", "url": "/design_resources/#{@file.id}/png_file.png", "content_type": "image/png", "file_size": 1677})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 200 ok when updating without passing in a file' do
      put :update, :design_id => @design.id, :id => @file.id, :file => ''
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/design_resources/#{@file.id}/text_file.txt", "content_type": "text/plain", "file_size": 20})).excluding('created_at').excluding('updated_at')
    end
    
    it 'should return 404 not found when attempting to update a non-existant design resource' do
      put :update, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end

  context '#deleting design resource' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @file = Fabricate(:design_resource, :file => upload_file('text_file.txt', 'text/plain'), :design => @design)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :design_id => @design.id, :id => @file.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "text_file.txt", "url": "/design_resources/#{@file.id}/text_file.txt", "content_type": "text/plain", "file_size": 20})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant design resource' do
      delete :destroy, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end
  
end

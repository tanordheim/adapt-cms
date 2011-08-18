# encoding: utf-8

require 'spec_helper'

describe Api::Version1::DesignsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/designs'}, :controller => 'api/version1/designs', :action => 'index')
    assert_routing({:method => :post, :path => '/api/v1/designs'}, :controller => 'api/version1/designs', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/designs/1'}, :controller => 'api/version1/designs', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/designs/1'}, :controller => 'api/version1/designs', :action => 'update', :id => '1')
    assert_routing({:method => :delete, :path => '/api/v1/designs/1'}, :controller => 'api/version1/designs', :action => 'destroy', :id => '1')
  end
  
  context '#retrieving design information' do
    before(:each) do
      mock_site
      @design1 = Fabricate(:design, :name => 'Design 1', :markup => 'Design 1 Markup', :site => Site.current)
      @design2 = Fabricate(:design, :name => 'Design 2', :markup => 'Design 2 Markup', :site => Site.current)
    end

    it 'should return design collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Design 1", "markup": "Design 1 Markup", "default": true},
          {"name": "Design 2", "markup": "Design 2 Markup", "default": false}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return design information in JSON format' do
      get :show, :id => @design1.id
      json = response.body
      json.should be_json_eql(%({"name": "Design 1", "markup": "Design 1 Markup", "default": true})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant design' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end

  context '#adding new design' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :name => 'Test Design', :markup => 'Test Design Markup'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Design", "markup": "Test Design Markup", "default": true})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :name => '', :markup => 'Test Design Markup'
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

  context '#updating design' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :name => 'Test Design', :markup => 'Test Design Markup', :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Design', :id => @design.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Design", "markup": "Test Design Markup", "default": true})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to update a non-existant design' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#deleting design' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :name => 'Test Design', :markup => 'Test Design Markup', :site => Site.current)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :id => @design.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Design", "markup": "Test Design Markup", "default": true})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant design' do
      delete :destroy, :id => 0
      response.response_code.should == 404
    end
  end
  
end

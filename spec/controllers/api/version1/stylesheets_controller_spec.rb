# encoding: utf-8

require 'spec_helper'

describe Api::Version1::StylesheetsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/designs/1/stylesheets'}, :controller => 'api/version1/stylesheets', :action => 'index', :design_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/designs/1/stylesheets'}, :controller => 'api/version1/stylesheets', :action => 'create', :design_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/designs/1/stylesheets/2'}, :controller => 'api/version1/stylesheets', :action => 'show', :design_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/designs/1/stylesheets/2'}, :controller => 'api/version1/stylesheets', :action => 'update', :design_id => '1', :id => '2')
    assert_routing({:method => :delete, :path => '/api/v1/designs/1/stylesheets/2'}, :controller => 'api/version1/stylesheets', :action => 'destroy', :design_id => '1', :id => '2')
  end

  context '#retrieving stylesheet information' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @stylesheet1 = Fabricate(:stylesheet, :filename => 'stylesheet1', :data => 'Stylesheet 1 Data', :design => @design)
      @stylesheet2 = Fabricate(:stylesheet, :filename => 'stylesheet2', :data => 'Stylesheet 2 Data', :design => @design)
      @other_design = Fabricate(:design, :site => Site.current)
      @other_design_stylesheet = Fabricate(:stylesheet, :filename => 'otherdesign_stylesheet', :data => 'Other Design Stylesheet Data', :design => @other_design)
    end

    it 'should return stylesheet collection information in JSON format' do
      get :index, :design_id => @design.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"filename": "stylesheet1", "data": "Stylesheet 1 Data", "processor": "plain"},
          {"filename": "stylesheet2", "data": "Stylesheet 2 Data", "processor": "plain"}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return stylesheet information in JSON format' do
      get :show, :design_id => @design.id, :id => @stylesheet1.id
      json = response.body
      json.should be_json_eql(%({"filename": "stylesheet1", "data": "Stylesheet 1 Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when loading stylesheets from a non-existant design' do
      get :index, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new stylesheet' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :design_id => @design.id, :filename => 'test_stylesheet', :data => 'Test Stylesheet Data'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "test_stylesheet", "data": "Test Stylesheet Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :design_id => @design.id, :filename => 'test_stylesheet', :data => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"data": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to create a stylesheet under a non-existant design' do
      post :create, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#updating stylesheet' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @stylesheet = Fabricate(:stylesheet, :filename => 'test_stylesheet', :data => 'Test Stylesheet Data', :design => @design)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :design_id => @design.id, :id => @stylesheet.id, :filename => 'updated_test_stylesheet'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "updated_test_stylesheet", "data": "Test Stylesheet Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :design_id => @design.id, :id => @stylesheet.id, :data => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"data": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant stylesheet' do
      put :update, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#deleting stylesheet' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @stylesheet = Fabricate(:stylesheet, :filename => 'test_stylesheet', :data => 'Test Stylesheet Data', :design => @design)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :design_id => @design.id, :id => @stylesheet.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "test_stylesheet", "data": "Test Stylesheet Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant stylesheet' do
      delete :destroy, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end
  
end

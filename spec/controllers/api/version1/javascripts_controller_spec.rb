# encoding: utf-8

require 'spec_helper'

describe Api::Version1::JavascriptsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/designs/1/javascripts'}, :controller => 'api/version1/javascripts', :action => 'index', :design_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/designs/1/javascripts'}, :controller => 'api/version1/javascripts', :action => 'create', :design_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/designs/1/javascripts/2'}, :controller => 'api/version1/javascripts', :action => 'show', :design_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/designs/1/javascripts/2'}, :controller => 'api/version1/javascripts', :action => 'update', :design_id => '1', :id => '2')
    assert_routing({:method => :delete, :path => '/api/v1/designs/1/javascripts/2'}, :controller => 'api/version1/javascripts', :action => 'destroy', :design_id => '1', :id => '2')
  end

  context '#retrieving javascript information' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @javascript1 = Fabricate(:javascript, :filename => 'javascript1', :data => 'Javascript 1 Data', :design => @design)
      @javascript2 = Fabricate(:javascript, :filename => 'javascript2', :data => 'Javascript 2 Data', :design => @design)
      @other_design = Fabricate(:design, :site => Site.current)
      @other_design_javascript = Fabricate(:javascript, :filename => 'otherdesign_javascript', :data => 'Other Design Javascript Data', :design => @other_design)
    end

    it 'should return javascript collection information in JSON format' do
      get :index, :design_id => @design.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"filename": "javascript1", "data": "Javascript 1 Data", "processor": "plain"},
          {"filename": "javascript2", "data": "Javascript 2 Data", "processor": "plain"}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return javascript information in JSON format' do
      get :show, :design_id => @design.id, :id => @javascript1.id
      json = response.body
      json.should be_json_eql(%({"filename": "javascript1", "data": "Javascript 1 Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when loading javascripts from a non-existant design' do
      get :index, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new javascript' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :design_id => @design.id, :filename => 'test_javascript', :data => 'Test Javascript Data'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "test_javascript", "data": "Test Javascript Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :design_id => @design.id, :filename => 'test_javascript', :data => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"data": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to create a javascript under a non-existant design' do
      post :create, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#updating javascript' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @javascript = Fabricate(:javascript, :filename => 'test_javascript', :data => 'Test Javascript Data', :design => @design)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :design_id => @design.id, :id => @javascript.id, :filename => 'updated_test_javascript'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "updated_test_javascript", "data": "Test Javascript Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :design_id => @design.id, :id => @javascript.id, :data => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"data": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant javascript' do
      put :update, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#deleting javascript' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @javascript = Fabricate(:javascript, :filename => 'test_javascript', :data => 'Test Javascript Data', :design => @design)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :design_id => @design.id, :id => @javascript.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "test_javascript", "data": "Test Javascript Data", "processor": "plain"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant javascript' do
      delete :destroy, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end

end

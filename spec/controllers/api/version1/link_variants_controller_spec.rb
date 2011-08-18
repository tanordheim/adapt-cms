# encoding: utf-8

require 'spec_helper'

describe Api::Version1::LinkVariantsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/link_variants'}, :controller => 'api/version1/link_variants', :action => 'index')
    assert_routing({:method => :post, :path => '/api/v1/link_variants'}, :controller => 'api/version1/link_variants', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/link_variants/1'}, :controller => 'api/version1/link_variants', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/link_variants/1'}, :controller => 'api/version1/link_variants', :action => 'update', :id => '1')
  end

  context '#retrieving link variant information' do
    before(:each) do
      mock_site
      @variant1 = Fabricate(:link_variant, :name => 'Variant 1', :site => Site.current)
      @variant2 = Fabricate(:link_variant, :name => 'Variant 2', :site => Site.current)
      @other_variant = Fabricate(:page_variant, :name => 'Page Variant', :site => Site.current)
    end

    it 'should return link variant collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Variant 1", "fields": []},
          {"name": "Variant 2", "fields": []}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return link variant information in JSON format' do
      get :show, :id => @variant1.id
      json = response.body
      json.should be_json_eql(%({"name": "Variant 1", "fields": []})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant link variant' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new link variant' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :name => 'Test Variant'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Variant", "fields": []})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :name => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end
  
  context '#updating link variant' do
    before(:each) do
      mock_site
      @variant = Fabricate(:link_variant, :name => 'Test Variant', :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Variant', :id => @variant.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Variant", "fields": []})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => '', :id => @variant.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end
  
end

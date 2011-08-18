# encoding: utf-8

require 'spec_helper'

describe Api::Version1::PageVariantsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/page_variants'}, :controller => 'api/version1/page_variants', :action => 'index')
    assert_routing({:method => :post, :path => '/api/v1/page_variants'}, :controller => 'api/version1/page_variants', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/page_variants/1'}, :controller => 'api/version1/page_variants', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/page_variants/1'}, :controller => 'api/version1/page_variants', :action => 'update', :id => '1')
  end

  context '#retrieving page variant information' do
    before(:each) do
      mock_site
      @variant1 = Fabricate(:page_variant, :name => 'Variant 1', :site => Site.current)
      @variant2 = Fabricate(:page_variant, :name => 'Variant 2', :site => Site.current)
      @other_variant = Fabricate(:link_variant, :name => 'Link Variant', :site => Site.current)
    end

    it 'should return page variant collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Variant 1", "fields": []},
          {"name": "Variant 2", "fields": []}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return page variant information in JSON format' do
      get :show, :id => @variant1.id
      json = response.body
      json.should be_json_eql(%({"name": "Variant 1", "fields": []})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant page variant' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new page variant' do
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
  
  context '#updating page variant' do
    before(:each) do
      mock_site
      @variant = Fabricate(:page_variant, :name => 'Test Variant', :site => Site.current)
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

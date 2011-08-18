# encoding: utf-8

require 'spec_helper'

describe Api::Version1::VariantFields::StringFieldsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/variants/1/string_fields'}, :controller => 'api/version1/variant_fields/string_fields', :action => 'index', :variant_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/variants/1/string_fields'}, :controller => 'api/version1/variant_fields/string_fields', :action => 'create', :variant_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/variants/1/string_fields/2'}, :controller => 'api/version1/variant_fields/string_fields', :action => 'show', :variant_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/variants/1/string_fields/2'}, :controller => 'api/version1/variant_fields/string_fields', :action => 'update', :variant_id => '1', :id => '2')
  end

  context '#retrieving string variant field information' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
      @field1 = Fabricate(:string_variant_field, :name => 'Field 1', :key => 'field_1', :variant => @variant)
      @field2 = Fabricate(:string_variant_field, :name => 'Field 2', :key => 'field_2', :variant => @variant)
      @non_string_field = Fabricate(:variant_field, :name => 'Other Field', :key => 'other_field', :variant => @variant)
    end

    it 'should return string variant field collection information in JSON format' do
      get :index, :variant_id => @variant.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Field 1", "key": "field_1", "required": false, "classification": "string_field"},
          {"name": "Field 2", "key": "field_2", "required": false, "classification": "string_field"}
        ]
      })
    end

    it 'should return string variant field information in JSON format' do
      get :show, :variant_id => @variant.id, :id => @field1.id
      json = response.body
      json.should be_json_eql(%({"name": "Field 1", "key": "field_1", "required": false, "classification": "string_field"}))
    end

    it 'should return 404 not found when attempting to retrieve a non-string variant field' do
      get :show, :variant_id => @variant.id, :id => @non_string_field.id
      response.response_code.should == 404
    end
  end

  context '#adding new string variant field' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :variant_id => @variant.id, :name => 'Test Field', :key => 'test_field'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Field", "key": "test_field", "required": false, "classification": "string_field"}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :variant_id => @variant.id, :name => '', :key => 'test_field'
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

  context '#updating string variant field' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
      @field = Fabricate(:string_variant_field, :name => 'Test Field', :key => 'test_field', :variant => @variant)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :variant_id => @variant.id, :name => 'Updated Test Field', :id => @field.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Field", "key": "test_field", "required": false, "classification": "string_field"}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :variant_id => @variant.id, :name => '', :id => @field.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when updating a non-existant string variant field' do
      put :update, :variant_id => @variant.id, :id => 0
      response.response_code.should == 404
    end
  end

end

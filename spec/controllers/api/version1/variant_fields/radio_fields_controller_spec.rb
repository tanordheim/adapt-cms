# encoding: utf-8

require 'spec_helper'

describe Api::Version1::VariantFields::RadioFieldsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/variants/1/radio_fields'}, :controller => 'api/version1/variant_fields/radio_fields', :action => 'index', :variant_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/variants/1/radio_fields'}, :controller => 'api/version1/variant_fields/radio_fields', :action => 'create', :variant_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/variants/1/radio_fields/2'}, :controller => 'api/version1/variant_fields/radio_fields', :action => 'show', :variant_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/variants/1/radio_fields/2'}, :controller => 'api/version1/variant_fields/radio_fields', :action => 'update', :variant_id => '1', :id => '2')
  end

  context '#retrieving radio variant field information' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
      @field1 = Fabricate(:radio_variant_field, :name => 'Field 1', :key => 'field_1', :variant => @variant, :options => ['Option1', 'Option2'])
      @field2 = Fabricate(:radio_variant_field, :name => 'Field 2', :key => 'field_2', :variant => @variant, :options => ['Option3', 'Option4'])
      @non_radio_field = Fabricate(:variant_field, :name => 'Other Field', :key => 'other_field', :variant => @variant)
    end

    it 'should return radio variant field collection information in JSON format' do
      get :index, :variant_id => @variant.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Field 1", "key": "field_1", "required": false, "classification": "radio_field", "options": ["Option1", "Option2"]},
          {"name": "Field 2", "key": "field_2", "required": false, "classification": "radio_field", "options": ["Option3", "Option4"]}
        ]
      })
    end

    it 'should return radio variant field information in JSON format' do
      get :show, :variant_id => @variant.id, :id => @field1.id
      json = response.body
      json.should be_json_eql(%({"name": "Field 1", "key": "field_1", "required": false, "classification": "radio_field", "options": ["Option1", "Option2"]}))
    end

    it 'should return 404 not found when attempting to retrieve a non-radio variant field' do
      get :show, :variant_id => @variant.id, :id => @non_radio_field.id
      response.response_code.should == 404
    end
  end

  context '#adding new radio variant field' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :variant_id => @variant.id, :name => 'Test Field', :key => 'test_field'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Field", "key": "test_field", "required": false, "classification": "radio_field", "options": []}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :variant_id => @variant.id, :name => '', :key => 'test_field'
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

  context '#updating radio variant field' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
      @field = Fabricate(:radio_variant_field, :name => 'Test Field', :key => 'test_field', :variant => @variant)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :variant_id => @variant.id, :name => 'Updated Test Field', :id => @field.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Field", "key": "test_field", "required": false, "classification": "radio_field", "options": []}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :variant_id => @variant.id, :name => '', :id => @field.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when updating a non-existant radio variant field' do
      put :update, :variant_id => @variant.id, :id => 0
      response.response_code.should == 404
    end
  end
  
end

# encoding: utf-8

require 'spec_helper'

describe Api::Version1::VariantFieldsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/variants/1/fields'}, :controller => 'api/version1/variant_fields', :action => 'index', :variant_id => '1')
    assert_routing({:method => :delete, :path => '/api/v1/variants/1/fields/2'}, :controller => 'api/version1/variant_fields', :action => 'destroy', :variant_id => '1', :id => '2')
  end

  context '#retrieving variant field information' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
      @field1 = Fabricate(:variant_field, :name => 'Field 1', :key => 'field_1', :variant => @variant)
      @field3 = Fabricate(:select_variant_field, :name => 'Field 3', :key => 'field_2', :variant => @variant, :options => ['Option 1', 'Option 2'])
      @field2 = Fabricate(:string_variant_field, :name => 'Field 2', :key => 'field_3', :variant => @variant)
      @other_variant = Fabricate(:variant, :site => Site.current)
      @other_variant_field = Fabricate(:variant_field, :name => 'Other Variant Field', :key => 'other_variant_field', :variant => @other_variant)
    end

    it 'should return variant field collection information in JSON format' do
      get :index, :variant_id => @variant.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Field 1", "key": "field_1", "required": false, "classification": "field"},
          {"name": "Field 3", "key": "field_2", "required": false, "classification": "select_field", "options": ["Option 1", "Option 2"]},
          {"name": "Field 2", "key": "field_3", "required": false, "classification": "string_field"}
        ]
      })
    end

    it 'should return 404 not found when loading variant fields from a non-existant variant' do
      get :index, :variant_id => 0
      response.response_code.should == 404
    end
  end

  context '#deleting variant field' do
    before(:each) do
      mock_site
      @variant = Fabricate(:variant, :site => Site.current)
      @field = Fabricate(:variant_field, :name => 'Test Field', :key => 'test_field', :variant => @variant)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :variant_id => @variant.id, :id => @field.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Field", "key": "test_field", "required": false, "classification": "field"}))
    end

    it 'should return 404 not found when deleting a non-existant variant field' do
      delete :destroy, :variant_id => @variant.id, :id => 0
      response.response_code.should == 404
    end

    it 'should return 404 not found when attempting to delete a variant field from a non-existant variant' do
      delete :destroy, :variant_id => 0, :id => @variant.id
      response.response_code.should == 404
    end
  end

end

# encoding: utf-8

require 'spec_helper'

describe Api::Version1::FormFieldsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/forms/1/fields'}, :controller => 'api/version1/form_fields', :action => 'index', :form_id => '1')
    assert_routing({:method => :delete, :path => '/api/v1/forms/1/fields/2'}, :controller => 'api/version1/form_fields', :action => 'destroy', :form_id => '1', :id => '2')
  end

  context '#retrieving form field information' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
      @field1 = Fabricate(:form_field, :name => 'Field 1', :default_text => 'Default Text', :form => @form)
      @field3 = Fabricate(:select_form_field, :name => 'Field 3', :default_text => 'Default Text', :form => @form, :options => ['Option 1', 'Option 2'])
      @field2 = Fabricate(:string_form_field, :name => 'Field 2', :default_text => 'Default Text', :form => @form)
      @other_form = Fabricate(:form, :site => Site.current)
      @other_form_field = Fabricate(:form_field, :name => 'Other Form Field', :form => @other_form)
    end

    it 'should return form field collection information in JSON format' do
      get :index, :form_id => @form.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Field 1", "required": false, "default_text": "Default Text", "classification": "field"},
          {"name": "Field 3", "required": false, "default_text": "Default Text", "classification": "select_field", "options": ["Option 1", "Option 2"]},
          {"name": "Field 2", "required": false, "default_text": "Default Text", "classification": "string_field"}
        ]
      })
    end

    it 'should return 404 not found when loading form fields from a non-existant form' do
      get :index, :form_id => 0
      response.response_code.should == 404
    end
  end

  context '#deleting form field' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
      @field = Fabricate(:form_field, :name => 'Test Field', :default_text => 'Default Text', :form => @form)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :form_id => @form.id, :id => @field.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Field", "required": false, "default_text": "Default Text", "classification": "field"}))
    end

    it 'should return 404 not found when deleting a non-existant form field' do
      delete :destroy, :form_id => @form.id, :id => 0
      response.response_code.should == 404
    end

    it 'should return 404 not found when attempting to delete a form field from a non-existant form' do
      delete :destroy, :form_id => 0, :id => @field.id
      response.response_code.should == 404
    end
  end
  
end

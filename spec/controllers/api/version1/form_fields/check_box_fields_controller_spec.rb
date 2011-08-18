# encoding: utf-8

require 'spec_helper'

describe Api::Version1::FormFields::CheckBoxFieldsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/forms/1/check_box_fields'}, :controller => 'api/version1/form_fields/check_box_fields', :action => 'index', :form_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/forms/1/check_box_fields'}, :controller => 'api/version1/form_fields/check_box_fields', :action => 'create', :form_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/forms/1/check_box_fields/2'}, :controller => 'api/version1/form_fields/check_box_fields', :action => 'show', :form_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/forms/1/check_box_fields/2'}, :controller => 'api/version1/form_fields/check_box_fields', :action => 'update', :form_id => '1', :id => '2')
  end

  context '#retrieving check box form field information' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
      @field1 = Fabricate(:check_box_form_field, :name => 'Field 1', :default_text => 'Default Text', :form => @form, :options => ['Option1', 'Option2'])
      @field2 = Fabricate(:check_box_form_field, :name => 'Field 2', :default_text => 'Default Text', :form => @form, :options => ['Option3', 'Option4'])
      @non_check_box_field = Fabricate(:form_field, :name => 'Other Field', :form => @form)
    end

    it 'should return check box form field collection information in JSON format' do
      get :index, :form_id => @form.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Field 1", "required": false, "default_text": "Default Text", "classification": "check_box_field", "options": ["Option1", "Option2"]},
          {"name": "Field 2", "required": false, "default_text": "Default Text", "classification": "check_box_field", "options": ["Option3", "Option4"]}
        ]
      })
    end

    it 'should return check box form field information in JSON format' do
      get :show, :form_id => @form.id, :id => @field1.id
      json = response.body
      json.should be_json_eql(%({"name": "Field 1", "required": false, "default_text": "Default Text", "classification": "check_box_field", "options": ["Option1", "Option2"]}))
    end

    it 'should return 404 not found when attempting to retrieve a non-check box form field' do
      get :show, :form_id => @form.id, :id => @non_check_box_field.id
      response.response_code.should == 404
    end
  end

  context '#adding new check box form field' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :form_id => @form.id, :name => 'Test Field'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Field", "required": false, "default_text": null, "classification": "check_box_field", "options": []}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :form_id => @form.id, :name => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

  context '#updating check box form field' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
      @field = Fabricate(:check_box_form_field, :name => 'Test Field', :default_text => 'Default Text', :form => @form)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :form_id => @form.id, :name => 'Updated Test Field', :id => @field.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Field", "required": false, "default_text": "Default Text", "classification": "check_box_field", "options": []}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :form_id => @form.id, :name => '', :id => @field.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when updating a non-existant check box form field' do
      put :update, :form_id => @form.id, :id => 0
      response.response_code.should == 404
    end
  end
  
end

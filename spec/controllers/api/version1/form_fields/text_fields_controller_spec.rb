# encoding: utf-8

require 'spec_helper'

describe Api::Version1::FormFields::TextFieldsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/forms/1/text_fields'}, :controller => 'api/version1/form_fields/text_fields', :action => 'index', :form_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/forms/1/text_fields'}, :controller => 'api/version1/form_fields/text_fields', :action => 'create', :form_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/forms/1/text_fields/2'}, :controller => 'api/version1/form_fields/text_fields', :action => 'show', :form_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/forms/1/text_fields/2'}, :controller => 'api/version1/form_fields/text_fields', :action => 'update', :form_id => '1', :id => '2')
  end

  context '#retrieving text form field information' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
      @field1 = Fabricate(:text_form_field, :name => 'Field 1', :default_text => 'Default Text', :form => @form)
      @field2 = Fabricate(:text_form_field, :name => 'Field 2', :default_text => 'Default Text', :form => @form)
      @non_text_field = Fabricate(:form_field, :name => 'Other Field', :form => @form)
    end

    it 'should return text form field collection information in JSON format' do
      get :index, :form_id => @form.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Field 1", "required": false, "default_text": "Default Text", "classification": "text_field"},
          {"name": "Field 2", "required": false, "default_text": "Default Text", "classification": "text_field"}
        ]
      })
    end

    it 'should return text form field information in JSON format' do
      get :show, :form_id => @form.id, :id => @field1.id
      json = response.body
      json.should be_json_eql(%({"name": "Field 1", "required": false, "default_text": "Default Text", "classification": "text_field"}))
    end

    it 'should return 404 not found when attempting to retrieve a non-text form field' do
      get :show, :form_id => @form.id, :id => @non_text_field.id
      response.response_code.should == 404
    end
  end

  context '#adding new text form field' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :form_id => @form.id, :name => 'Test Field'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Field", "required": false, "default_text": null, "classification": "text_field"}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :form_id => @form.id, :name => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

  context '#updating text form field' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :site => Site.current)
      @field = Fabricate(:text_form_field, :name => 'Test Field', :default_text => 'Default Text', :form => @form)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :form_id => @form.id, :name => 'Updated Test Field', :id => @field.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Field", "required": false, "default_text": "Default Text", "classification": "text_field"}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :form_id => @form.id, :name => '', :id => @field.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when updating a non-existant text form field' do
      put :update, :form_id => @form.id, :id => 0
      response.response_code.should == 404
    end
  end
  
end

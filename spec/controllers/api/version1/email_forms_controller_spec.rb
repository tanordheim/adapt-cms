# encoding: utf-8

require 'spec_helper'

describe Api::Version1::EmailFormsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/email_forms'}, :controller => 'api/version1/email_forms', :action => 'index')
    assert_routing({:method => :post, :path => '/api/v1/email_forms'}, :controller => 'api/version1/email_forms', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/email_forms/1'}, :controller => 'api/version1/email_forms', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/email_forms/1'}, :controller => 'api/version1/email_forms', :action => 'update', :id => '1')
  end

  context '#retrieving email form information' do
    before(:each) do
      mock_site
      @form1 = Fabricate(:email_form, :name => 'Form 1', :submit_text => "Submit Form", :email_address => 'test@test.com', :site => Site.current)
      @form2 = Fabricate(:email_form, :name => 'Form 2', :submit_text => "Submit Form", :email_address => 'test@test.com', :site => Site.current)
      @non_email_form = Fabricate(:form, :name => 'Non-Email Form', :site => Site.current)
    end

    it 'should return email form collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Form 1", "submit_text": "Submit Form", "success_url": "/", "variant": "email_form", "email_address": "test@test.com"},
          {"name": "Form 2", "submit_text": "Submit Form", "success_url": "/", "variant": "email_form", "email_address": "test@test.com"}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return email form information in JSON format' do
      get :show, :id => @form1.id
      json = response.body
      json.should be_json_eql(%({"name": "Form 1", "submit_text": "Submit Form", "success_url": "/", "variant": "email_form", "email_address": "test@test.com"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-email form' do
      get :show, :id => @non_email_form.id
      response.response_code.should == 404
    end
  end

  context '#adding new email form' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :name => 'Test Form', :submit_text => 'Submit Form', :success_url => '/', :email_address => 'test@test.com'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Form", "submit_text": "Submit Form", "success_url": "/", "variant": "email_form", "email_address": "test@test.com"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :name => '', :submit_text => 'Submit Form', :success_url => '/', :email_address => 'test@test.com'
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end
  
  context '#updating email form' do
    before(:each) do
      mock_site
      @form = Fabricate(:email_form, :name => 'Test Form', :submit_text => "Submit Form", :email_address => 'test@test.com', :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Form', :id => @form.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Updated Test Form", "submit_text": "Submit Form", "success_url": "/", "variant": "email_form", "email_address": "test@test.com"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => '', :id => @form.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when updating a non-existant email form' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end

end

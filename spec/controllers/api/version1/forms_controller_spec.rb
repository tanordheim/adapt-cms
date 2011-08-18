# encoding: utf-8

require 'spec_helper'

describe Api::Version1::FormsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/forms'}, :controller => 'api/version1/forms', :action => 'index')
    assert_routing({:method => :delete, :path => '/api/v1/forms/1'}, :controller => 'api/version1/forms', :action => 'destroy', :id => '1')
  end

  context '#retrieving form information' do
    before(:each) do
      mock_site
      @form1 = Fabricate(:form, :name => 'Form 1', :submit_text => "Submit Form", :site => Site.current)
      @form2 = Fabricate(:form, :name => 'Form 2', :submit_text => "Submit Form", :site => Site.current)
    end

    it 'should return form collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Form 1", "submit_text": "Submit Form", "success_url": "/", "variant": "form"},
          {"name": "Form 2", "submit_text": "Submit Form", "success_url": "/", "variant": "form"}
        ]
      }).excluding('created_at').excluding('updated_at')
    end
  end
  
  context '#deleting form' do
    before(:each) do
      mock_site
      @form = Fabricate(:form, :name => 'Test Form', :submit_text => "Submit Form", :site => Site.current)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :id => @form.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Form", "submit_text": "Submit Form", "success_url": "/", "variant": "form"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when deleting a non-existant form' do
      delete :destroy, :id => 0
      response.response_code.should == 404
    end
  end
  
end

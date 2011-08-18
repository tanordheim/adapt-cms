require 'spec_helper'

describe Api::Version1::SiteController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/site'}, :controller => 'api/version1/site', :action => 'show')
    assert_routing({:method => :put, :path => '/api/v1/site'}, :controller => 'api/version1/site', :action => 'update')
  end

  context '#retrieving site information' do
    before(:each) do
      mock_site
    end

    it 'should return site information in JSON format' do
      get :show
      json = response.body
      json.should be_json_eql(%({"subdomain": "test", "locale": "en", "name": "Test Site"}))
    end
  end

  context '#updating site information' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Site'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"subdomain": "test", "locale": "en", "name": "Updated Test Site"}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

end

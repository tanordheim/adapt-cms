require 'spec_helper'

describe Api::Version1::AdminController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/admin'}, :controller => 'api/version1/admin', :action => 'show')
    assert_routing({:method => :put, :path => '/api/v1/admin'}, :controller => 'api/version1/admin', :action => 'update')
  end

  context '#retrieving admin information' do
    before(:each) do
      mock_site
    end

    it 'should return admin information in JSON format' do
      get :show
      json = response.body
      json.should be_json_eql(%({"email": "test@test.com", "name": "Test Administrator"}))
    end
  end

  context '#updating admin information' do
    before(:each) do
      mock_site
    end

    it 'should return 200k ok when successfully updating' do
      put :update, :name => 'Updated Test Administrator'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"email": "test@test.com", "name": "Updated Test Administrator"}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end
  end

end

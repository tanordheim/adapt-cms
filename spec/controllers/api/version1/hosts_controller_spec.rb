# encoding: utf-8

require 'spec_helper'

describe Api::Version1::HostsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/hosts'}, :controller => 'api/version1/hosts', :action => 'index')
    assert_routing({:method => :post, :path => '/api/v1/hosts'}, :controller => 'api/version1/hosts', :action => 'create')
    assert_routing({:method => :get, :path => '/api/v1/hosts/1'}, :controller => 'api/version1/hosts', :action => 'show', :id => '1')
    assert_routing({:method => :put, :path => '/api/v1/hosts/1'}, :controller => 'api/version1/hosts', :action => 'update', :id => '1')
    assert_routing({:method => :delete, :path => '/api/v1/hosts/1'}, :controller => 'api/version1/hosts', :action => 'destroy', :id => '1')
  end

  context '#retrieving host information' do
    before(:each) do
      mock_site
    end

    it 'should return host collection information in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%([{"hostname": "www1.test.com", "primary": true}, {"hostname": "www2.test.com", "primary": false}]))
    end

    it 'should return host information in JSON format' do
      get :show, :id => Site.current.hosts.first.id
      json = response.body
      json.should be_json_eql(%({"hostname": "www1.test.com", "primary": true}))
    end

    it 'should return 404 not found when retrieving a non-existant host' do
      get :show, :id => 0
      response.response_code.should == 404
    end
  end

  context '#adding new host' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :hostname => 'www3.test.com'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"hostname": "www3.test.com", "primary": false}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :hostname => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"hostname": ["can't be blank"]}))
    end
  end

  context '#updating host' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :hostname => 'www1.example.com', :id => Site.current.hosts.first.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"hostname": "www1.example.com", "primary": true}))
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :hostname => '', :id => Site.current.hosts.first.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"hostname": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant host' do
      put :update, :id => 0
      response.response_code.should == 404
    end
  end

  context '#deleting host' do
    before(:each) do
      mock_site
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :id => Site.current.hosts.first.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"hostname": "www1.test.com", "primary": true}))
    end

    it 'should return 404 not found when attempting to delete a non-existant host' do
      put :destroy, :id => 0
      response.response_code.should == 404
    end
  end

end

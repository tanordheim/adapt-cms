# encoding: utf-8

require 'spec_helper'

describe Api::Version1::VariantsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :delete, :path => '/api/v1/variants/1'}, :controller => 'api/version1/variants', :action => 'destroy', :id => '1')
  end

  context '#deleting variant' do
    before(:each) do
      mock_site
      @variant = Fabricate(:page_variant, :name => 'Test Variant', :site => Site.current)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :id => @variant.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Variant", "fields": []})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when deleting a non-existant variant' do
      delete :destroy, :id => 0
      response.response_code.should == 404
    end
  end
  
end

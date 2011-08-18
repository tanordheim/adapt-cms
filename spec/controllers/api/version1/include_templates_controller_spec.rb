# encoding: utf-8

require 'spec_helper'

describe Api::Version1::IncludeTemplatesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
  
  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/designs/1/include_templates'}, :controller => 'api/version1/include_templates', :action => 'index', :design_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/designs/1/include_templates'}, :controller => 'api/version1/include_templates', :action => 'create', :design_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/designs/1/include_templates/2'}, :controller => 'api/version1/include_templates', :action => 'show', :design_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/designs/1/include_templates/2'}, :controller => 'api/version1/include_templates', :action => 'update', :design_id => '1', :id => '2')
    assert_routing({:method => :delete, :path => '/api/v1/designs/1/include_templates/2'}, :controller => 'api/version1/include_templates', :action => 'destroy', :design_id => '1', :id => '2')
  end

  context '#retrieving include template information' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @template1 = Fabricate(:include_template, :filename => 'template1', :markup => 'Template 1 Markup', :design => @design)
      @template2 = Fabricate(:include_template, :filename => 'template2', :markup => 'Template 2 Markup', :design => @design)
      @other_design = Fabricate(:design, :site => Site.current)
      @other_design_template = Fabricate(:include_template, :filename => 'otherdesign_template', :markup => 'Other Design Template Markup', :design => @other_design)
    end

    it 'should return include template collection information in JSON format' do
      get :index, :design_id => @design.id
      json = response.body
      json.should be_json_eql(%{
        [
          {"filename": "template1", "markup": "Template 1 Markup"},
          {"filename": "template2", "markup": "Template 2 Markup"}
        ]
      }).excluding('created_at').excluding('updated_at')
    end

    it 'should return include template information in JSON format' do
      get :show, :design_id => @design.id, :id => @template1.id
      json = response.body
      json.should be_json_eql(%({"filename": "template1", "markup": "Template 1 Markup"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when loading include templates from a non-existant design' do
      get :index, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#adding new include template' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :design_id => @design.id, :filename => 'test_template', :markup => 'Test Template Markup'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "test_template", "markup": "Test Template Markup"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :design_id => @design.id, :filename => 'test_template', :markup => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"markup": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to coreate an include template under a non-existant design' do
      post :create, :design_id => 0
      response.response_code.should == 404
    end
  end
  
  context '#updating include template' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @template = Fabricate(:include_template, :filename => 'test_template', :markup => 'Test Template Markup', :design => @design)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :design_id => @design.id, :id => @template.id, :filename => 'updated_test_template'
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "updated_test_template", "markup": "Test Template Markup"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :design_id => @design.id, :id => @template.id, :markup => ''
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"markup": ["can't be blank"]}))
    end
    
    it 'should return 404 not found when attempting to update a non-existant include template' do
      put :update, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end
  
  context '#deleting include template' do
    before(:each) do
      mock_site
      @design = Fabricate(:design, :site => Site.current)
      @template = Fabricate(:include_template, :filename => 'test_template', :markup => 'Test Template Markup', :design => @design)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :design_id => @design.id, :id => @template.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"filename": "test_template", "markup": "Test Template Markup"})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant include template' do
      delete :destroy, :design_id => @design.id, :id => 0
      response.response_code.should == 404
    end
  end
  
end

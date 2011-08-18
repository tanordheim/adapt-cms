require 'spec_helper'

describe Api::Version1::NodesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/nodes'}, :controller => 'api/version1/nodes', :action => 'index')
    assert_routing({:method => :delete, :path => '/api/v1/nodes/1'}, :controller => 'api/version1/nodes', :action => 'destroy', :id => '1')
  end

  context '#retrieving node information' do
    before(:each) do
      mock_site
      @root1 = Fabricate(:node, :name => 'Root 1', :creator => current_admin, :updater => current_admin, :site => Site.current)
      @child1 = Fabricate(:node, :name => 'Child 1', :parent => @root1, :creator => current_admin, :updater => current_admin, :site => Site.current)
      @third_level_child = Fabricate(:node, :name => 'Third Level Child', :parent => @child1, :creator => current_admin, :updater => current_admin, :site => Site.current)
      @child2 = Fabricate(:node, :name => 'Child 2', :parent => @root1, :creator => current_admin, :updater => current_admin, :site => Site.current)
      @root2 = Fabricate(:node, :name => 'Root 2', :creator => current_admin, :updater => current_admin, :site => Site.current)
      @blog = Fabricate(:blog, :name => 'Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
      @blog_post = Fabricate(:blog_post, :name => 'Test Post', :parent => @blog, :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return full node collection information, except blog posts, in JSON format' do
      get :index
      json = response.body
      json.should be_json_eql(%{
        [
          {"name": "Root 1", "published": true, "show_in_navigation": true, "uri": "root_1", "classification": "node", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": [
            {"name": "Child 1", "published": true, "show_in_navigation": true, "uri": "root_1/child_1", "classification": "node", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": [
              {"name": "Third Level Child", "published": true, "show_in_navigation": true, "uri": "root_1/child_1/third_level_child", "classification": "node", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": []}
            ]},
            {"name": "Child 2", "published": true, "show_in_navigation": true, "uri": "root_1/child_2", "classification": "node", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": []}
          ]},
          {"name": "Root 2", "published": true, "show_in_navigation": true, "uri": "root_2", "classification": "node", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": []},
          {"name": "Blog", "published": true, "show_in_navigation": true, "uri": "blog", "classification": "blog", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": []}
        ]
      }).excluding('created_at').excluding('updated_at')
    end
  end

  context '#deleting node' do
    before(:each) do
      mock_site
      @node = Fabricate(:node, :name => 'Test Node', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully deleting' do
      delete :destroy, :id => @node.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"name": "Test Node", "published": true, "show_in_navigation": true, "uri": "test_node", "classification": "node", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "children": []})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to delete a non-existant node' do
      delete :destroy, :id => 0
      response.response_code.should == 404
    end
  end
  
end

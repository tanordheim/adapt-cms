# encoding: utf-8

require 'spec_helper'

describe Api::Version1::BlogPostsController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it 'should have valid routes' do
    assert_routing({:method => :get, :path => '/api/v1/blogs/1/posts'}, :controller => 'api/version1/blog_posts', :action => 'index', :parent_id => '1')
    assert_routing({:method => :post, :path => '/api/v1/blogs/1/posts'}, :controller => 'api/version1/blog_posts', :action => 'create', :parent_id => '1')
    assert_routing({:method => :get, :path => '/api/v1/blogs/1/posts/2'}, :controller => 'api/version1/blog_posts', :action => 'show', :parent_id => '1', :id => '2')
    assert_routing({:method => :put, :path => '/api/v1/blogs/1/posts/2'}, :controller => 'api/version1/blog_posts', :action => 'update', :parent_id => '1', :id => '2')
  end

  context '#retrieving blog post information' do
    before(:each) do
      mock_site
      @blog = Fabricate(:blog, :name => 'Test Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
      @post1 = Fabricate(:blog_post, :name => 'Test Post 1', :parent => @blog, :published_on => Date.parse('2011-08-31'), :creator => current_admin, :updater => current_admin, :site => Site.current)
      @post2 = Fabricate(:blog_post, :name => 'Test Post 2', :parent => @blog, :published_on => Date.parse('2011-08-31'), :creator => current_admin, :updater => current_admin, :site => Site.current)
      @other_blog = Fabricate(:blog, :name => 'Other Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
      @other_blog_post = Fabricate(:blog_post, :name => 'Other Blog Post', :parent => @other_blog, :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return blog posts in JSON format' do
      get :index, :parent_id => @blog.id
      json = response.body
      json.should be_json_eql(%([
        {"parents": [{"uri": "test_blog", "name": "Test Blog", "classification": "blog"}], "variant_id": null, "name": "Test Post 2", "published": true, "published_on": "2011-08-31", "show_in_navigation": true, "slug": "test_post_2", "uri": "test_blog/test_post_2", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}},
        {"parents": [{"uri": "test_blog", "name": "Test Blog", "classification": "blog"}], "variant_id": null, "name": "Test Post 1", "published": true, "published_on": "2011-08-31", "show_in_navigation": true, "slug": "test_post_1", "uri": "test_blog/test_post_1", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}}
      ])).excluding('created_at').excluding('updated_at')
    end

    it 'should return blog post information in JSON format' do
      get :show, :parent_id => @blog.id, :id => @post1.id
      json = response.body
      json.should be_json_eql(%({"parents": [{"uri": "test_blog", "name": "Test Blog", "classification": "blog"}], "variant_id": null, "name": "Test Post 1", "published": true, "published_on": "2011-08-31", "show_in_navigation": true, "slug": "test_post_1", "uri": "test_blog/test_post_1", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 404 not found when attempting to retrieve a non-existant blog post' do
      get :show, :parent_id => @blog.id, :id => 0
      response.response_code.should == 404
    end

    it 'should return 404 not found when attempting to retrieve a blog post from a non-existant blog' do
      get :show, :parent_id => 0, :id => @post1.id
      response.response_code.should == 404
    end
  end
  
  context '#adding new blog post' do
    before(:each) do
      mock_site
      @blog = Fabricate(:blog, :name => 'Test Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully creating' do
      post :create, :name => 'Test Post', :published_on => '2011-08-31', :parent_id => @blog.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"parents": [{"uri": "test_blog", "name": "Test Blog", "classification": "blog"}], "variant_id": null, "name": "Test Post", "published": true, "published_on": "2011-08-31", "show_in_navigation": true, "slug": "test_post", "uri": "test_blog/test_post", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      post :create, :name => '', :published_on => '2011-08-31', :parent_id => @blog.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to create a blog post under a non-blog node' do
      page = Fabricate(:page, :name => 'Test Page', :creator => current_admin, :updater => current_admin, :site => Site.current)
      post :create, :name => 'Test Post', :parent_id => page.id
      json = response.body
      response.response_code.should == 404
    end
  end
 
  context '#updating blog post' do
    before(:each) do
      mock_site
      @blog = Fabricate(:blog, :name => 'Test Blog', :creator => current_admin, :updater => current_admin, :site => Site.current)
      @post = Fabricate(:blog_post, :name => 'Test Post', :published_on => Date.parse('2011-08-31'), :parent => @blog, :creator => current_admin, :updater => current_admin, :site => Site.current)
    end

    it 'should return 200 ok when successfully updating' do
      put :update, :name => 'Updated Test Post', :parent_id => @blog.id, :id => @post.id
      json = response.body
      response.response_code.should == 200
      json.should be_json_eql(%({"parents": [{"uri": "test_blog", "name": "Test Blog", "classification": "blog"}], "variant_id": null, "name": "Updated Test Post", "published": true, "published_on": "2011-08-31", "show_in_navigation": true, "slug": "test_post", "uri": "test_blog/test_post", "creator_id": #{current_admin.id}, "updater_id": #{current_admin.id}, "data": {}})).excluding('created_at').excluding('updated_at')
    end

    it 'should return 422 unprocessable entity when validation fails' do
      put :update, :name => '', :parent_id => @blog.id, :id => @post.id
      json = response.body
      response.response_code.should == 422
      json.should be_json_eql(%({"name": ["can't be blank"]}))
    end

    it 'should return 404 not found when attempting to update a non-existant blog post' do
      put :update, :parent_id => @blog.id, :id => 0
      response.response_code.should == 404
    end

    it 'should return 404 not found when attempting to update a blog post for a non-existant blog' do
      put :update, :parent_id => 0, :id => @post.id
      response.response_code.should == 404
    end
  end
  
end

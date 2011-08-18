# encoding: utf-8

require 'spec_helper'

describe Blog do

  context '#classification' do
    it 'should return the classification "blog"' do
      Fabricate(:blog).classification.should == 'blog'
    end
  end

  context '#posts' do
    let(:blog_with_posts) do
      site = Fabricate(:site)
      blog = Fabricate(:blog, :site => site)
      post1 = Fabricate(:blog_post, :parent => blog, :site => site)
      post2 = Fabricate(:blog_post, :parent => blog, :site => site)
      page = Fabricate(:page, :parent => blog, :site => site)
      blog
    end

    it 'should return the blog post nodes as posts' do
      blog_with_posts.posts.size.should == 2
    end
  end

end

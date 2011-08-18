# encoding: utf-8

require 'spec_helper'

describe BlogPost do

  context '#attributes' do
    it { should have_db_column(:published_on).of_type(:date) }
  end

  context '#validations' do
    it { should validate_presence_of(:published_on) }
  end
  
  context '#classification' do
    it 'should return the classification "blog_post"' do
      Fabricate(:blog_post).classification.should == 'blog_post'
    end
  end

  context '#parent must be blog' do
    let(:site) { Fabricate(:site) }
    it 'should not allow blog posts without a parent' do
      post = Fabricate.build(:blog_post, :parent => nil, :site => site)
      post.should_not be_valid
    end

    it 'should not allow blog posts with a non-blog parent' do
      page = Fabricate(:page, :site => site)
      post = Fabricate.build(:blog_post, :parent => page, :site => site)
      post.should_not be_valid
    end

    it 'should allow creating blog posts for a blog' do
      blog = Fabricate(:blog, :site => site)
      post = Fabricate.build(:blog_post, :parent => blog, :site => site)
      post.should be_valid
    end
  end

end

# encoding: utf-8

require 'spec_helper'

describe Variant do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:node_type).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:position).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should have_many(:fields).dependent(:destroy) }
    it { should have_many(:check_box_fields) }
    it { should have_many(:radio_fields) }
    it { should have_many(:resource_reference_fields) }
    it { should have_many(:form_reference_fields) }
    it { should have_many(:select_fields) }
    it { should have_many(:string_fields) }
    it { should have_many(:text_fields) }
  end

  context '#validations' do
    before(:each) { Fabricate(:variant) }
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:node_type) }
    it { should allow_value('blog').for(:node_type) }
    it { should allow_value('blog_post').for(:node_type) }
    it { should allow_value('link').for(:node_type) }
    it { should allow_value('page').for(:node_type) }
    it { should_not allow_value('test').for(:node_type) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to([:site_id, :node_type]).case_insensitive }
  end
  
end

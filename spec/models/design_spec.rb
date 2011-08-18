# encoding: utf-8

require 'spec_helper'

describe Design do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:default).of_type(:boolean).with_options(:null => false, :default => false) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:markup).of_type(:text).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should have_many(:include_templates).dependent(:destroy) }
    it { should have_many(:view_templates).dependent(:destroy) }
    it { should have_many(:resources).dependent(:destroy) }
    it { should have_many(:stylesheets).dependent(:destroy) }
    it { should have_many(:javascripts).dependent(:destroy) }
  end

  context '#validations' do
    before(:each) { Fabricate(:design) }
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:site_id).case_insensitive }
    it { should validate_presence_of(:markup) }
  end

  context '#default design' do
    let(:site) { Fabricate(:site) }

    it 'should set the first design created as the default' do
      Fabricate(:design, :default => false).default.should be_true
    end

    it 'should set the second design created as non-default unless specified, and leave the default design as the default' do
      default_design = Fabricate(:design, :default => true, :site => site)
      second_design = Fabricate(:design, :site => site)
      default_design.reload
      second_design.reload
      default_design.default.should be_true
      second_design.default.should be_false
    end

    it 'should set the default design to non-default if a new default design is created' do
      default_design = Fabricate(:design, :default => true, :site => site)
      new_default_design = Fabricate(:design, :default => true, :site => site)
      default_design.reload
      new_default_design.reload
      default_design.default.should be_false
      new_default_design.default.should be_true
    end

    it 'should set the default design to non-default if a new default design is updated' do
      default_design = Fabricate(:design, :default => true, :site => site)
      new_default_design = Fabricate(:design, :site => site)
      new_default_design.default = true
      new_default_design.save
      default_design.reload
      new_default_design.reload
      default_design.default.should be_false
      new_default_design.default.should be_true
    end
  end
  
end

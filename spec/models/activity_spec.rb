# encoding: utf-8

require 'spec_helper'

describe Activity do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:parent_id).of_type(:integer) }
    it { should have_db_column(:author_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:source_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:source_type).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:source_name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:action).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:count).of_type(:integer).with_options(:null => false, :default => 1) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should belong_to(:author) }
    it { should belong_to(:source) }
  end
  
  context '#validations' do
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:action) }
    it { should allow_value('create').for(:action) }
    it { should allow_value('update').for(:action) }
    it { should_not allow_value('test').for(:action) }
  end
  
end

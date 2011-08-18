# encoding: utf-8

require 'spec_helper'

describe SitePrivilege do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:admin_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should belong_to(:admin) }
    it { should have_many(:roles).dependent(:destroy) }
  end

  context '#validations' do
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:admin) }
  end
  
end

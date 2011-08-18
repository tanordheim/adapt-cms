# encoding: utf-8

require 'spec_helper'

describe Admin do

  context '#attributes' do
    it { should have_db_column(:email).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should have_many(:site_privileges).dependent(:destroy) }
    it { should have_many(:sites).through(:site_privileges) }
  end

  context '#validations' do
    before(:each) { Fabricate(:admin) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:name) }
  end

  context '#privileges' do
    let(:site) { Fabricate(:site) }
    let(:other_site) { Fabricate(:site) }
    let(:admin) do
      admin = Fabricate(:admin)
      Fabricate(:site_privilege, :site => site, :admin => admin)
      admin
    end

    it 'should check if an admin has privileges for a site' do
      admin.has_privileges_for?(site).should == true
    end

    it 'should not grant admins access to site without privileges' do
      admin.has_privileges_for?(other_site).should == false
    end
  end
  
end

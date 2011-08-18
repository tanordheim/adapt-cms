# encoding: utf-8

require 'spec_helper'

describe SitePrivilegeRole do

  context '#attributes' do
    it { should have_db_column(:site_privilege_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:role).of_type(:string).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site_privilege) }
  end

  context '#validations' do
    it { should validate_presence_of(:site_privilege) }
    it { should validate_presence_of(:role) }
  end
  
end

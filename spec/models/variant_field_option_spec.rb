# encoding: utf-8

require 'spec_helper'

describe VariantFieldOption do

  context '#attributes' do
    it { should have_db_column(:variant_field_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:value).of_type(:string).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:field) }
  end

  context '#validations' do
    before(:each) { Fabricate(:variant_field_option) }
    it { should validate_presence_of(:field) }
    it { should validate_presence_of(:value) }
    it { should validate_uniqueness_of(:value).scoped_to(:variant_field_id).case_insensitive }
  end
  
end

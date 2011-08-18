# encoding: utf-8

require 'spec_helper'

describe VariantAttribute do

  context '#attributes' do
    it { should have_db_column(:node_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:key).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:value).of_type(:text) }
  end

  context '#associations' do
    it { should belong_to(:node) }
  end

  context '#validations' do
    before(:each) { Fabricate(:variant_attribute) }
    it { should validate_presence_of(:node) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key).scoped_to(:node_id).case_insensitive }

    # Keys must be at least 4 characters in length and start with a normal
    # character. They can not contain spaces and must contain only normal
    # characters, numbers, dashes and underscores.
    it { should allow_value('test').for(:key) }
    it { should allow_value('t1234').for(:key) }
    it { should allow_value('t-est').for(:key) }
    it { should allow_value('t_est').for(:key) }
    it { should_not allow_value('tæst').for(:key) }     # Contains an abnormal character.
    it { should_not allow_value('t est').for(:key) }    # Contains a space
    it { should_not allow_value('1234').for(:key) }     # Doesnt start with a normal character.
    it { should_not allow_value('tst').for(:key) }      # Less than 4 characters.
  end
  
end

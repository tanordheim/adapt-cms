# encoding: utf-8

require 'spec_helper'

describe VariantField do

  context '#attributes' do
    it { should have_db_column(:variant_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:position).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:key).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:required).of_type(:boolean).with_options(:null => false, :default => false) }
  end

  context '#associations' do
    it { should belong_to(:variant) }
  end

  context '#validations' do
    it { should validate_presence_of(:variant) }
    it { should validate_presence_of(:key) }
    it 'should not allow duplicate keys' do
      field1 = Fabricate(:variant_field)
      field2 = Fabricate.build(:variant_field, :key => field1.key, :variant => field1.variant)
      field2.should_not be_valid
    end
    it 'should allow duplicate keys for different variants' do
      field1 = Fabricate(:variant_field)
      field2 = Fabricate.build(:variant_field, :key => field1.key)
      field2.should be_valid
    end

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
    
    it { should validate_presence_of(:name) }
  end

  context '#classification' do
    it 'should return the classification "field"' do
      Fabricate(:variant_field).classification.should == 'field'
    end
  end
  
end

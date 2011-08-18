# encoding: utf-8

require 'spec_helper'

describe FormField do

  context '#attributes' do
    it { should have_db_column(:form_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:position).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:default_text).of_type(:text) }
    it { should have_db_column(:required).of_type(:boolean).with_options(:null => false, :default => false) }
  end

  context '#associations' do
    it { should belong_to(:form) }
  end

  context '#validations' do
    before(:each) { Fabricate(:form_field) }
    it { should validate_presence_of(:form) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:form_id).case_insensitive }
  end

  context '#classification' do
    it 'should return the classification "field"' do
      Fabricate(:form_field).classification.should == 'field'
    end
  end

  context '#liquid' do
    let(:liquid) { field.to_liquid }
    let(:field) { Fabricate(:string_form_field, :name => 'Test Field', :default_text => 'Test Value') }

    it 'should contain the id' do
      liquid['id'].should == field.id
    end

    it 'should contain the name' do
      liquid['name'].should == 'Test Field'
    end

    it 'should contain the default text' do
      liquid['default_text'].should == 'Test Value'
    end

    it 'should contain the classification' do
      liquid['classification'].should == 'string_field'
    end

    it 'should not have the options array' do
      liquid.key?('options').should be_false
    end
    
    context '#field with options' do
      let(:field) { Fabricate(:select_form_field, :options => ['Option 1', 'Option 2']) }

      it 'should have the options array' do
        liquid['options'].should == ['Option 1', 'Option 2']
      end
    end
  end
end

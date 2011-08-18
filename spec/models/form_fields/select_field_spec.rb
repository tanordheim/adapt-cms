# encoding: utf-8

require 'spec_helper'

describe FormFields::SelectField do

  context '#associations' do
    it { should have_many(:form_field_options).dependent(:destroy) }
  end
  
  context '#classification' do
    it 'should return the classification "select_field"' do
      Fabricate(:select_form_field).classification.should == 'select_field'
    end
  end

  context '#options' do
    let(:field) do
      Fabricate(:select_form_field, :options => ['Option 1', 'Option 2'])
    end

    it 'should build two form field options' do
      field.form_field_options.count.should == 2
    end

    it 'should return the options as an array' do
      field.options.should == ['Option 1', 'Option 2']
    end

    it 'should replace the pre-existing fields when adding new ones' do
      field.options = ['New Option']
      field.save
      field.form_field_options.count.should == 1
      field.options.should == ['New Option']
    end

    it 'should not remove pre-existing fields until saved' do
      field.options = ['New Option']
      field.reload
      field.form_field_options.count.should == 2
    end
  end
  
end

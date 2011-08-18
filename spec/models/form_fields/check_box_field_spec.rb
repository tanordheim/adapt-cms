# encoding: utf-8

require 'spec_helper'

describe FormFields::CheckBoxField do

  context '#associations' do
    it { should have_many(:form_field_options).dependent(:destroy) }
  end

  context '#classification' do
    it 'should return the classification "check_box_field"' do
      Fabricate(:check_box_form_field).classification.should == 'check_box_field'
    end
  end
  
  context '#options' do
    let(:field) do
      Fabricate(:check_box_form_field, :options => ['Option 1', 'Option 2'])
    end

    it 'should build two form field options' do
      field.form_field_options.count.should == 2
    end

    it 'should return the options as an array in the same order as they were created in' do
      field.options.should == ['Option 1', 'Option 2']
    end

    it 'should return the options as an array in the same order as they were updated in' do
      field.options = ['Option 3', 'Option 4']
      field.save
      field.reload
      field.options.should == ['Option 3', 'Option 4']
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

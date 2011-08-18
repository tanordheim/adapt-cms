# encoding: utf-8

require 'spec_helper'

describe VariantFields::CheckBoxField do

  context '#classification' do
    it 'should return the classification "check_box_field"' do
      Fabricate(:check_box_variant_field).classification.should == 'check_box_field'
    end
  end
  
end

# encoding: utf-8

require 'spec_helper'

describe VariantFields::TextField do

  context '#classification' do
    it 'should return the classification "text_field"' do
      Fabricate(:text_variant_field).classification.should == 'text_field'
    end
  end
  
end

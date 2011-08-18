# encoding: utf-8

require 'spec_helper'

describe VariantFields::StringField do

  context '#classification' do
    it 'should return the classification "string_field"' do
      Fabricate(:string_variant_field).classification.should == 'string_field'
    end
  end
  
end

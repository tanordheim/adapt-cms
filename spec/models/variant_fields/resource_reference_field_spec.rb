# encoding: utf-8

require 'spec_helper'

describe VariantFields::ResourceReferenceField do

  context '#classification' do
    it 'should return the classification "resource_reference_field"' do
      Fabricate(:resource_reference_variant_field).classification.should == 'resource_reference_field'
    end
  end
  
end

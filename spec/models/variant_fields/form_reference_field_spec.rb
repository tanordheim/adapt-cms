# encoding: utf-8

require 'spec_helper'

describe VariantFields::FormReferenceField do

  context '#classification' do
    it 'should return the classification "form_reference_field"' do
      Fabricate(:form_reference_variant_field).classification.should == 'form_reference_field'
    end
  end
  
end

# encoding: utf-8

require 'spec_helper'

describe FormFields::StringField do

  context '#classification' do
    it 'should return the classification "string_field"' do
      Fabricate(:string_form_field).classification.should == 'string_field'
    end
  end
  
end

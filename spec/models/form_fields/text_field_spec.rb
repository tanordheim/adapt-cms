# encoding: utf-8

require 'spec_helper'

describe FormFields::TextField do

  context '#classification' do
    it 'should return the classification "text_field"' do
      Fabricate(:text_form_field).classification.should == 'text_field'
    end
  end
  
end

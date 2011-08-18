# encoding: utf-8

require 'spec_helper'

describe Page do

  context '#classification' do
    it 'should return the classification "page"' do
      Fabricate(:page).classification.should == 'page'
    end
  end
  
end

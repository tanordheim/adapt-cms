# encoding: utf-8

require 'spec_helper'

describe Link do

  context '#attributes' do
    it { should have_db_column(:href).of_type(:string) }
  end

  context '#validations' do
    it { should validate_presence_of(:href) }
  end
  
  context '#classification' do
    it 'should return the classification "link"' do
      Fabricate(:link).classification.should == 'link'
    end
  end

  context '#liquid' do
    let(:link) { Fabricate(:link, :href => 'http://www.test.com/') }
    let(:liquid) { link.to_liquid }

    it 'should contain the url' do
      liquid['href'].should == 'http://www.test.com/'
    end
  end
  
end

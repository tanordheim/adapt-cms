# encoding: utf-8

require 'spec_helper'

describe EmailForm do

  context '#attributes' do
    it { should have_db_column(:email_address).of_type(:string) }
  end

  context '#validations' do
    it { should validate_presence_of(:email_address) }
  end

  context '#variant' do
    it 'should return the variant "email_form"' do
      Fabricate(:email_form).variant.should == 'email_form'
    end
  end

end

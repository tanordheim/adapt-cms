# encoding: utf-8

require 'spec_helper'

describe Form do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:success_url).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:submit_text).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should have_many(:fields).dependent(:destroy) }
    it { should have_many(:text_fields) }
    it { should have_many(:string_fields) }
    it { should have_many(:check_box_fields) }
    it { should have_many(:select_fields) }
  end

  context '#validations' do
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:submit_text) }
    it { should validate_presence_of(:success_url) }
  end

  context '#variant' do
    it 'should return the variant "form"' do
      Fabricate(:form).variant.should == 'form'
    end
  end

  context '#liquid' do
    let(:form) do
      form = Fabricate(:form, :name => 'Test Form', :submit_text => 'Submit Form')
      Fabricate(:string_form_field, :name => 'String Field', :form => form)
      Fabricate(:select_form_field, :name => 'Select Field', :form => form, :options => ['Option 1', 'Option 2'])
      form
    end
    let(:liquid) { form.to_liquid }

    it 'should return a hash' do
      liquid.should be_a(Hash)
    end

    it 'should contain the id' do
      liquid['id'].should == form.id
    end

    it 'should contain the name' do
      liquid['name'].should == 'Test Form'
    end

    it 'should contain the uri' do
      liquid['uri'].should == "/forms/#{form.id}"
    end

    it 'should contain the submit text' do
      liquid['submit_text'].should == 'Submit Form'
    end

    context '#fields' do
      it 'should contain the fields' do
        liquid['fields'].should be_an(Array)
        liquid['fields'].size.should == 2
      end
    end
  end

end

require 'spec_helper'

describe DesignResource do

  context '#attributes' do
    it { should have_db_column(:design_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:file).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:content_type).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:file_size).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:design) }
  end

  context '#validations' do
    it { should validate_presence_of(:design) }
    it { should validate_presence_of(:file) }
  end

  context '#meta data' do
    let(:resource) { Fabricate(:design_resource, :file => upload_file('text_file.txt', 'text/plain')) }

    it 'should assign the filename after uploading' do
      resource.filename.should == 'text_file.txt'
    end

    it 'should assign the content type after uploading' do
      resource.content_type.should == 'text/plain'
    end

    it 'should assign the file size after uploading' do
      resource.file_size.should == 20
    end
  end

  context '#liquid' do
    let(:design_resource) { Fabricate(:design_resource, :file => upload_file('text_file.txt', 'text/plain')) }
    let(:liquid) { design_resource.to_liquid }

    it 'should return a hash' do
      liquid.should be_a(Hash)
    end

    it 'should contain the filename' do
      liquid['filename'].should == 'text_file.txt'
    end

    it 'should contain the url' do
      liquid['url'].should == "/design_resources/#{design_resource.id}/text_file.txt"
    end
  end

end

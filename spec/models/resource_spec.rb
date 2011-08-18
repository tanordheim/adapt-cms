require 'spec_helper'

describe Resource do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:file).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:content_type).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:file_size).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:creator_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:updater_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should belong_to(:creator) }
    it { should belong_to(:updater) }
  end

  context '#validations' do
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:file) }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:updater) }
  end

  context '#meta data' do
    let(:resource) { Fabricate(:resource, :file => upload_file('text_file.txt', 'text/plain')) }

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
    let(:resource) { Fabricate(:resource, :file => upload_file('text_file.txt', 'text/plain')) }
    let(:liquid) { resource.to_liquid }

    it 'should return a hash' do
      liquid.should be_a(Hash)
    end

    it 'should contain the filename' do
      liquid['filename'].should == 'text_file.txt'
    end

    it 'should contain the url' do
      liquid['url'].should == "/resources/#{resource.id}/text_file.txt"
    end
  end
  
  context '#activities' do
    let(:site) { Fabricate(:site) }
    let(:author) { Fabricate(:admin) }
    let(:second_author) { Fabricate(:admin) }
    let(:resource) { Fabricate(:resource, :site => site, :file => upload_file('text_file.txt', 'text/plain'), :creator => author, :updater => author) }

    it 'should create an activity when creating a resource' do
      resource
      Activity.count.should == 1
    end

    it 'should create an activity when updating a resource' do
      resource.file = upload_file('png_file.png', 'image/png')
      resource.save!
      Activity.count.should == 2
    end

    it 'should increase count on an update activity when the same author performs the change' do
      resource.file = upload_file('png_file.png', 'image/png')
      resource.save!
      resource.file = upload_file('text_file.txt', 'text/plain')
      resource.save!
      Activity.count.should == 2
      Activity.where(:action => 'update').first.count.should == 2
    end

    it 'should add a separate activity when two different authors performs the change' do
      resource.file = upload_file('png_file.png', 'image/png')
      resource.save!
      resource.file = upload_file('text_file.txt', 'text/plain')
      resource.updater = second_author
      resource.save!
      Activity.count.should == 3
    end
  end
  
end

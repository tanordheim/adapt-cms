# encoding: utf-8

require 'spec_helper'

describe Stylesheet do

  context '#attributes' do
    it { should have_db_column(:design_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:processor).of_type(:string).with_options(:null => false, :default => 'plain') }
    it { should have_db_column(:filename).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:data).of_type(:text).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:design) }
  end

  context '#validations' do
    before(:each) { Fabricate(:stylesheet) }
    it { should validate_presence_of(:design) }
    it { should validate_presence_of(:processor) }
    it { should allow_value('plain').for(:processor) }
    it { should allow_value('sass').for(:processor) }
    it { should allow_value('scss').for(:processor) }
    it { should_not allow_value('test').for(:processor) }

    it { should validate_presence_of(:filename) }
    it { should validate_uniqueness_of(:filename).scoped_to(:design_id).case_insensitive }

    # Filenames must only contain normal characters, numbers, dashes,
    # underscores and dots.
    it { should allow_value('test').for(:filename) }
    it { should allow_value('Test').for(:filename) }
    it { should allow_value('t1234').for(:filename) }
    it { should allow_value('t.est').for(:filename) }
    it { should allow_value('t.est-_').for(:filename) }
    it { should_not allow_value('tæst').for(:filename) }     # Contains an abnormal character.
    it { should_not allow_value('t est').for(:filename) }    # Contains a space.
    
    it { should validate_presence_of(:data) }
  end
  
end

# encoding: utf-8

require 'spec_helper'

describe Node do

  context '#attributes' do
    it { should have_db_column(:site_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:ancestry).of_type(:string) }
    it { should have_db_column(:slug).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:uri).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:published).of_type(:boolean).with_options(:null => false, :default => true) }
    it { should have_db_column(:show_in_navigation).of_type(:boolean).with_options(:null => false, :default => true) }
    it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
    it { should have_db_column(:creator_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:updater_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
  end

  context '#associations' do
    it { should belong_to(:site) }
    it { should belong_to(:variant) }
    it { should have_many(:variant_attributes).dependent(:destroy) }
    it { should belong_to(:creator) }
    it { should belong_to(:updater) }
    it { should have_many(:activities).dependent(:destroy) }
  end

  context '#validations' do
    it { should validate_presence_of(:site) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:updater) }
  end

  context '#slugs' do
    it 'should assign a default slug if no slug is specified' do
      Fabricate(:node, :name => 'Test Node').slug.should == 'test_node'
    end

    it 'should accept the specified slug' do
      Fabricate(:node, :slug => 'test_node').slug.should == 'test_node'
    end
  end

  context '#uris' do

    context '#root nodes' do
      it 'should build the uri when creating a node' do
        Fabricate(:node, :slug => 'test_node').uri.should == 'test_node'
      end

      it 'should build the uri when updating a node' do
        node = Fabricate(:node, :slug => 'test_node')
        node.slug = 'updated_test_node'
        node.save
        node.uri.should == 'updated_test_node'
      end
    end

    context '#child nodes' do
      let(:root) { Fabricate(:node, :slug => 'root') }

      it 'should build the uri when creating a node' do
        Fabricate(:node, :slug => 'test_node', :parent => root).uri.should == 'root/test_node'
      end

      it 'should build the uri when updating a node' do
        node = Fabricate(:node, :slug => 'test_node', :parent => root)
        node.slug = 'updated_test_node'
        node.save
        node.uri.should == 'root/updated_test_node'
      end
    end
    
    context '#deep nested nodes' do
      let(:root) { Fabricate(:node, :slug => 'root') }
      let(:parent) { Fabricate(:node, :slug => 'parent', :parent => root) }

      it 'should update descendant uris when parent uri change' do
        node = Fabricate(:node, :slug => 'descendant', :parent => parent)
        child_node = Fabricate(:node, :slug => 'deep_descendant', :parent => node)
        parent.slug = 'updated_parent'
        parent.save
        node.reload
        node.uri.should == 'root/updated_parent/descendant'
        child_node.reload
        child_node.uri.should == 'root/updated_parent/descendant/deep_descendant'
      end
    end

    context '#moving nodes' do
      pending 'Moving node tests have been disabled now due to randomly failing, especially when running the full test suite. Moving nodes isnt implemented in any UI yet, but fix this later.'
      # let(:root1) { Fabricate(:node, :slug => 'root1') }
      # let(:root2) { Fabricate(:node, :slug => 'root2') }

      # it 'should change the uri when a node is moved' do
      #   node = Fabricate(:node, :slug => 'child', :parent => root1)
      #   node.parent = root2
      #   node.save
      #   node.uri.should == 'root2/child'
      # end

      # it 'should change the uri of descendants when a parent node is moved' do
      #   parent = Fabricate(:node, :slug => 'parent', :parent => root1)
      #   node = Fabricate(:node, :slug => 'descendant', :parent => parent)
      #   child_node = Fabricate(:node, :slug => 'deep_descendant', :parent => node)

      #   parent.parent = root2
      #   parent.save
      #   node.reload
      #   child_node.reload

      #   node.uri.should == 'root2/parent/descendant'
      #   child_node.uri.should == 'root2/parent/descendant/deep_descendant'
      # end
    end

  end

  context '#children as json' do
    before(:each) { Timecop.freeze(timestamp) }
    after(:each) { Timecop.return }

    let(:site) { Fabricate(:site) }
    let(:timestamp) { Time.now }
    let(:author) { Fabricate(:admin) }
    let(:root) { Fabricate(:node, :name => 'Root', :site => site, :creator => author, :updater => author, :created_at => timestamp, :updated_at => timestamp) }
    let(:leaf_child) { Fabricate(:node, :name => 'Child', :parent => root, :site => site, :creator => author, :updater => author, :created_at => timestamp, :updated_at => timestamp) }
    let(:branch_child) do
      child = Fabricate(:node, :name => 'Child', :parent => root, :site => site, :creator => author, :updater => author, :created_at => timestamp, :updated_at => timestamp)
      second_child = Fabricate(:node, :name => 'Second Child', :parent => child, :site => site, :creator => author, :updater => author, :created_at => timestamp, :updated_at => timestamp)
      child
    end
    let(:blog) do
      blog = Fabricate(:blog, :name => 'Blog', :site => site, :creator => author, :updater => author, :created_at => timestamp, :updated_at => timestamp)
      Fabricate(:blog_post, :name => 'Blog Post', :site => site, :parent => blog, :creator => author, :updater => author, :created_at => timestamp, :updated_at => timestamp)
      blog
    end

    it 'should have an empty array when no children' do
      root.children_as_json.should == []
    end

    it 'should return the children when having one level of children' do
      child = leaf_child
      root.children_as_json.should == [{:id => child.id, :name => 'Child', :published => true, :show_in_navigation => true, :uri => 'root/child', :classification => 'node', :creator_id => author.id, :updater_id => author.id, :created_at => timestamp, :updated_at => timestamp, :children => []}]
    end

    it 'should return the child tree when having several levels of children' do
      child = branch_child
      second_child = child.children.first
      second_child_json = [{:id => second_child.id, :name => 'Second Child', :published => true, :show_in_navigation => true, :uri => 'root/child/second_child', :classification => 'node', :creator_id => author.id, :updater_id => author.id, :created_at => timestamp, :updated_at => timestamp, :children => []}]
      root.children_as_json.should == [{:id => child.id, :name => 'Child', :published => true, :show_in_navigation => true, :uri => 'root/child', :classification => 'node', :created_at => timestamp, :creator_id => author.id, :updater_id => author.id, :updated_at => timestamp, :children => second_child_json}]
    end

    it 'should not include blog posts' do
      blog.children_as_json.should == []
    end
  end

  context '#parent array' do
    let(:site) { Fabricate(:site) }
    let(:root_node) { Fabricate(:node, :name => 'Root Node', :site => site) }
    let(:first_level_child_node) { Fabricate(:node, :name => 'First Level Child', :parent => root_node, :site => site) }
    let(:second_level_child_node) { Fabricate(:node, :name => 'Second Level Child', :parent => first_level_child_node, :site => site) }

    it 'should return an empty array for root nodes' do
      root_node.parents.should == []
    end

    it 'should return an array containing one element for first level child nodes' do
      first_level_child_node.parents.should == [{:id => root_node.id, :uri => 'root_node', :name => 'Root Node', :classification => 'node'}]
    end

    it 'should return an array containing two elements with the highest parent first for second level child nodes' do
      second_level_child_node.parents.should == [{:id => root_node.id, :uri => 'root_node', :name => 'Root Node', :classification => 'node'}, {:id => first_level_child_node.id, :uri => 'root_node/first_level_child', :name => 'First Level Child', :classification => 'node'}]
    end
  end

  context '#classification' do
    it 'should return the classification "node"' do
      Fabricate(:node).classification.should == 'node'
    end
  end

  context '#variants' do
    let(:site) { Fabricate(:site) }
    let(:page) { Fabricate(:page, :site => site) }
    let(:page_variant) do
      variant = Fabricate.build(:page_variant, :site => site)
      variant.string_fields.build(:key => 'string_field', :name => 'String Field')
      variant.text_fields.build(:key => 'text_field', :name => 'Text Field')
      variant.save!
      variant
    end
    let(:second_page_variant) do
      variant = Fabricate.build(:page_variant, :site => site)
      variant.string_fields.build(:key => 'test_field', :name => 'Test Field')
      variant.save!
      variant
    end

    context '#assigning variant' do
      let(:link_variant) { Fabricate(:link_variant, :site => site) }

      it 'should be able to assign variant by id' do
        page.variant_id = page_variant.id
        page.save
        page.reload
        page.variant.should == page_variant
      end

      it 'should be able to assign variant by model' do
        page.variant = page_variant
        page.save
        page.reload
        page.variant.should == page.variant
      end

      it 'should not be possible to assign variants for another model by id' do
        page.variant_id = link_variant.id
        page.should_not be_valid
      end

      it 'should not be possible to assign variants for another model by model' do
        page.variant = link_variant
        page.should_not be_valid
      end

    end

    context '#attribute blueprint' do
      it 'should define the variant attribute blueprint when assigning a variant' do
        page.variant = page_variant
        page.variant_attributes.size.should == 2
        page.variant_attributes.collect(&:key).should == ['string_field', 'text_field']
      end

      it 'should update the blueprint when assigning a new variant' do
        page.variant = page_variant
        page.variant = second_page_variant
        page.variant_attributes.size.should == 3
        page.variant_attributes.collect(&:key).should == ['string_field', 'text_field', 'test_field']
      end

      it 'should remove attributes not matching the variant when creating a node' do
        page.variant = page_variant
        page.variant = second_page_variant
        page.save
        page.reload
        page.variant_attributes.size.should == 1
      end

      it 'should remove attributes not matching the variant when updating a node' do
        page.variant = page_variant
        page.save
        page.reload
        page.variant = second_page_variant
        page.save
        page.reload
        page.variant_attributes.size.should == 1
      end

      it 'should remove all attributes when removing variant' do
        page.variant = page_variant
        page.save
        page.reload
        page.variant = nil
        page.save
        page.reload
        page.variant_attributes.size.should == 0
      end
    end

    context '#data hash' do
      it 'should build attributes when setting a data hash' do
        page.data = {:test => 'test', :foo => 'bar'}
        page.variant_attributes.size.should == 2
      end

      it 'should return the attributes as a hash' do
        page.variant = second_page_variant
        page.variant_attributes.first.value = 'Test Value'
        page.save
        page.reload
        page.data.should == {:test_field => 'Test Value'}
      end
    end
  end

  context '#liquid' do
    let(:site) { Fabricate(:site) }

    let(:variant) do
      variant = Fabricate(:page_variant, :name => 'Test Variant', :site => site)
      Fabricate(:string_variant_field, :key => 'string_field', :variant => variant)
      variant
    end

    let(:page) do

      page = Fabricate(:page, :site => site, :variant => variant, :data => {:string_field => 'Test Value'})

      # Add some children
      child = Fabricate(:page, :site => site, :parent => page)
      Fabricate(:page, :site => site, :parent => child)
      Fabricate(:page, :site => site, :parent => page, :show_in_navigation => false)

      page
      
    end

    let(:liquid) { page.to_liquid }

    let(:child_liquid) do
      page.children.first.to_liquid
    end

    let(:child_child_liquid) do
      page.children.first.children.first.to_liquid
    end

    it 'should return a hash' do
      liquid.should be_a(Hash)
    end

    it 'should contain the id' do
      liquid['id'].should == page.id
    end

    it 'should contain the classification' do
      liquid['classification'].should == 'page'
    end

    it 'should contain the view name' do
      liquid['view'].should == 'page.test_variant'
    end

    it 'should contain the uri' do
      liquid['uri'].should == page.uri
    end

    it 'should contain the name' do
      liquid['name'].should == page.name
    end

    it 'should contain the published flag' do
      liquid['published'].should == page.published
    end

    it 'should contain the show in navigation flag' do
      liquid['show_in_navigation'].should == page.show_in_navigation
    end

    it 'should contain a data field hash' do
      liquid['data'].should be_a(Hash)
    end

    it 'should contain the string_field data attribute' do
      liquid['data']['string_field'].should == page.data[:string_field]
    end

    it 'should contain the children of the page' do
      liquid['children'].size.should == 2
      liquid['children'].first['id'].should == page.children.sorted.first.id
      liquid['children'].last['id'].should == page.children.sorted.last.id
    end

    it 'should not nest children' do
      liquid['children'].first.key?('children').should be_false
    end

    it 'should contain the ancestors of the page' do
      child_child_liquid['ancestors'].collect { |node| node['id'] }.should == [ page.id, page.children.first.id ]
    end

    it 'should not nest ancestors' do
      child_child_liquid['ancestors'].first.key?('ancestors').should be_false
    end
    
    it 'should contain the navigation of the page' do
      liquid['navigation'].size.should == 1
      liquid['navigation'].first['id'].should == page.children.sorted.first.id
    end

    it 'should not nest navigation' do
      liquid['navigation'].first.key?('navigation').should be_false
    end

    it 'should include the parent of a child' do
      child_liquid['parent'].should be_a(Hash)
    end

    it 'should not include a parent on root' do
      liquid['parent'].should be_blank
    end

    it 'should include the top parent of a child' do
      child_liquid['root_parent'].should be_a(Hash)
    end

    it 'should not include root parent on root' do
      liquid['root_parent'].should be_blank
    end
    
  end

  context '#activities' do
    let(:site) { Fabricate(:site) }
    let(:author) { Fabricate(:admin) }
    let(:second_author) { Fabricate(:admin) }
    let(:node) { Fabricate(:page, :site => site, :name => 'Test Node', :creator => author, :updater => author) }

    it 'should create an activity when creating a node' do
      node
      Activity.count.should == 1
      Activity.first.source_type.should == 'Page'
    end

    it 'should create an activity when updating a node' do
      node.name = 'Updated Test Node'
      node.save!
      Activity.count.should == 2
    end

    it 'should increase count on an update activity when the same author performs the change' do
      node.name = 'Updated Test Node'
      node.save!
      node.name = 'Original Test Node'
      node.save!
      Activity.count.should == 2
      Activity.where(:action => 'update').first.count.should == 2
    end

    it 'should add a separate activity when two different authors performs the change' do
      node.name = 'Updated test Node'
      node.save!
      node.name = 'Original Test Node'
      node.updater = second_author
      node.save!
      Activity.count.should == 3
    end
  end
    
end

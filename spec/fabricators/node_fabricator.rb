Fabricator(:node) do
  site!
  name { Faker::Lorem.sentence }
  creator! { Fabricate(:admin) }
  updater! { Fabricate(:admin) }
end

Fabricator(:page, :from => :node, :class_name => :page) do
end

Fabricator(:link, :from => :node, :class_name => :link) do
  href { "http://#{Faker::Internet.domain_name}/" }
end

Fabricator(:blog, :from => :node, :class_name => :blog) do
end

Fabricator(:blog_post, :from => :node, :class_name => :blog_post) do
  parent { Fabricate(:blog) }
  published_on { Date.today - 10.days }
end

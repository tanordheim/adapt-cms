Fabricator(:variant) do
  site!
  node_type { Variant::NODE_TYPES.sample }
  name { sequence(:name) { |i| "Variant #{i}" } }
end

Fabricator(:blog_variant, :from => :variant) do
  node_type { 'blog' }
end

Fabricator(:blog_post_variant, :from => :variant) do
  node_type { 'blog_post' }
end

Fabricator(:link_variant, :from => :variant) do
  node_type { 'link' }
end

Fabricator(:page_variant, :from => :variant) do
  node_type { 'page' }
end

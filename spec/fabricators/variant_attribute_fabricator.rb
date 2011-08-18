Fabricator(:variant_attribute) do
  node!
  key { sequence(:key) { |i| "attribute_#{i}" } }
  value { Faker::Lorem.sentence }
end

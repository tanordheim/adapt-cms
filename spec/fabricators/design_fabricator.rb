Fabricator(:design) do
  site!
  name { sequence(:name) { |i| "Design #{i}" } }
  markup { Faker::Lorem.sentence }
end

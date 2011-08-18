Fabricator(:javascript) do
  design!
  filename { sequence(:filename) { |i| "javascript#{i}" } }
  data { Faker::Lorem.sentence }
end

Fabricator(:stylesheet) do
  design!
  filename { sequence(:filename) { |i| "stylesheet#{i}" } }
  data { Faker::Lorem.sentence }
end

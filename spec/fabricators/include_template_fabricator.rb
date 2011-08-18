Fabricator(:include_template) do
  design!
  filename { sequence(:filename) { |i| "template_#{i}" } }
  markup { Faker::Lorem.sentence }
end

Fabricator(:site_host) do
  site!
  hostname { sequence(:hostname) { |i| "www#{i}.#{Faker::Internet.domain_name}" } }
  primary { false }
end

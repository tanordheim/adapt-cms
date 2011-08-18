# encoding: utf-8

Fabricator(:site) do
  subdomain { sequence(:subdomain) { |i| "subdomain#{i}" } }
  name { Faker::Lorem.sentence }
  locale { 'en' }
end

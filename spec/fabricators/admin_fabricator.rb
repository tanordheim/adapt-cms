Fabricator(:admin) do
  name { Faker::Name.name }
  email { sequence(:email) { |i| "user_#{i}@adaptapp.com" } }
  password 'password'
  password_confirmation 'password'
end

Fabricator(:form) do
  site!
  name { Faker::Lorem.sentence }
  success_url { '/' }
  submit_text { Faker::Lorem.sentence(1) }
end

Fabricator(:email_form, :from => :form, :class_name => :email_form) do
  email_address { Faker::Internet.email }
end

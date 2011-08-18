Fabricator(:form_field) do
  form!
  name { Faker::Lorem.sentence }
  default_text { Faker::Lorem.sentence }
end

Fabricator(:text_form_field, :from => :form_field, :class_name => 'FormFields::TextField') do
end

Fabricator(:string_form_field, :from => :form_field, :class_name => 'FormFields::StringField') do
end

Fabricator(:check_box_form_field, :from => :form_field, :class_name => 'FormFields::CheckBoxField') do
end

Fabricator(:select_form_field, :from => :form_field, :class_name => 'FormFields::SelectField') do
end

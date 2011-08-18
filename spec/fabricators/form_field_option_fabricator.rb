Fabricator(:form_field_option) do
  field! { Fabricate(:form_field) }
  value { sequence(:value) { |i| "Value #{i}" } }
end

Fabricator(:variant_field_option) do
  field! { Fabricate(:variant_field) }
  value { sequence(:value) { |i| "Value #{i}" } }
end

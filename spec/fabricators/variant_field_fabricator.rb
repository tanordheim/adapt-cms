Fabricator(:variant_field) do
  variant!
  key { sequence(:key) { |i| "key#{i}" } }
  name { Faker::Lorem.sentence }
end

Fabricator(:string_variant_field, :from => :variant_field, :class_name => 'VariantFields::StringField') do
end

Fabricator(:text_variant_field, :from => :variant_field, :class_name => 'VariantFields::TextField') do
end

Fabricator(:resource_reference_variant_field, :from => :variant_field, :class_name => 'VariantFields::ResourceReferenceField') do
end

Fabricator(:form_reference_variant_field, :from => :variant_field, :class_name => 'VariantFields::FormReferenceField') do
end

Fabricator(:check_box_variant_field, :from => :variant_field, :class_name => 'VariantFields::CheckBoxField') do
end

Fabricator(:radio_variant_field, :from => :variant_field, :class_name => 'VariantFields::RadioField') do
end

Fabricator(:select_variant_field, :from => :variant_field, :class_name => 'VariantFields::SelectField') do
end

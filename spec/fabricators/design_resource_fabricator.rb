Fabricator(:design_resource) do
  design!
  file { upload_file('text_file.txt', 'text/plain') }
end

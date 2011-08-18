Fabricator(:resource) do
  site!
  file { upload_file('text_file.txt', 'text/plain') }
  creator! { Fabricate(:admin) }
  updater! { Fabricate(:admin) }
end

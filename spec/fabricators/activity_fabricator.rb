Fabricator(:activity) do
  site!
  author! { Fabricate(:admin) }
  source! { Fabricate(:node) }
end

# encoding: utf-8
# vim:ft=ruby

guard 'pow' do
  watch('.powrc')
  watch('.powenv')
  watch('.rvmrc')
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false, :cucumber => false do
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec/" }
end

guard 'rspec', :version => 2, :cli => '--drb --color --format nested --fail-fast', :all_on_start => false, :all_after_pass => false, :notification => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec/" }
  watch('spec/spec_helper.rb')                        { "spec/" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^spec/fabricators/(.+)_fabricator\.rb$})   { |m| "spec/models/#{m[1]}_spec.rb" }
end

guard 'process', :name => 'SunspotDevelopment', :command => 'bundle exec rake sunspot:solr:run', :env => { 'RAILS_ENV' => 'development' } do
end

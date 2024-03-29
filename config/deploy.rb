require 'bundler/capistrano'

set :application, 'adapt'

set :repository, 'git@github.com:tanordheim/adapt-cms.git'
set :scm, :git
set :branch, 'master'

set :user, 'app'
set :deploy_to, '/data/app/adapt'
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :default_environment, { 'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin/:$PATH" }

role :web, 'appsrv.local'
role :app, 'appsrv.local'
role :db, 'appsrv.local', :primary => true

# Server tasks, they do nothing since we use Unicorn.
namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do; end
end

# Reload Unicorn after deploying
namespace :unicorn do
  task :reload, :roles => :app, :except => { :no_release => true } do
    run 'sudo /usr/bin/bluepill adapt_production restart'
  end
end
after 'deploy:start', 'unicorn:reload'
after 'deploy:restart', 'unicorn:reload'

# Ensure the sockets directory where Unicorn places its socket file exists
namespace :support do
  task :create_socket_directory do
    run "mkdir -p #{shared_path}/sockets"
  end
end
after 'deploy:update_code', 'support:create_socket_directory'

# Precompile assets
namespace :assets do
  task :precompile, :roles => :app do
    invoke_command "cd #{latest_release}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end
before 'deploy:restart', 'assets:precompile'

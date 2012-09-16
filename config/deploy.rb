set :application, "subversion-stats"
set :domain,      "subversion-stats.com"

set :scm,         "git"
set :repository,  "git@github.com:bmaher/subversion-stats.git"
set :ssh_options, :forward_agent => true

set :user,        "deploy"
set :deploy_to,   "/var/www/#{application}"
set :use_sudo,    false

role :app, domain
role :web, domain
role :db,  domain, :primary => true

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.3-p0"

require "bundler/capistrano"
require "sidekiq/capistrano"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
  end

  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
    run "ln -nfs #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

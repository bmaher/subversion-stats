set :application, "subversion-stats"
set :domain,      "dojann.co.uk"

set :scm,         "git"
set :repository,  "git@github.com:bmaher/subversion-stats.git"

set :user,        "deploy"
set :deploy_to,   "/var/www/#{application}"
set :use_sudo,    false

role :app, domain
role :web, domain
role :db,  domain, :primary => true

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.3-p0"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
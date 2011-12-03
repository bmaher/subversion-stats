set :application, "subversion-stats"

set :repository,  "git@github.com:bmaher/subversion-stats.git"
set :scm, :git

set :user, "deploy"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

role :web, "dojann.co.uk"
role :app, "dojann.co.uk"
role :db,  "dojann.co.uk", :primary => true

after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"

namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle --deployment"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
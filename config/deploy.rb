set :application, "sdops.sourcedirect.com"
set :scm, :git
set :repository,  "git@mirrors:sdops.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :copy_exclude, [".svn", ".git"]
set :scm_verbose, true
set :runner, 'deploy'

set :keep_releases, 3

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

set :user, "deploy"
set :scm_passphrase, "zebwokra"
role :app, "sdops"
role :web, "sdops"
role :db,  "sdops", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
    run "ln -sf #{deploy_to}/shared/config/database.yml #{deploy_to}/current/config/database.yml"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
set :application, "sdops.sourcedirect.com"
set :scm, :git
#set :repository,  "git@rails:sdops.git"
set :repository,  "git@github.com:joshuawscott/sdops.git"
set :branch, "master"
set :deploy_via, :copy
set :copy_exclude, [".svn", ".git"]
set :scm_verbose, true
set :runner, 'depoly'
#ssh_options[:username] = "deploy"
#ssh_options[:forward_agent] = true
#ssh_options[:keys] = %w(/home/deploy/.ssh/id_rsa)
set :keep_releases, 3

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

set :user, "deploy"
set :scm_password, "zebwokra"
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
  namespace :data do
    desc "Load static data from db/data"
    task :roles do
      run("cd #{deploy_to}/current/ && /usr/bin/rake data:load RAILS_ENV=production DB_STATIC_TABLES=roles")
    end
  end
end


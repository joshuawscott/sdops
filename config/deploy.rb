set :application, "sdopps.sourcedirect.com"
set :scm, :git
set :repository,  "."
set :branch, "master"

set :runner, 'tnini'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

set :user, "tnini"
role :app, "acct.sourcedirect.com"
role :web, "acct.sourcedirect.com"
role :db,  "acct.sourcedirect.com", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
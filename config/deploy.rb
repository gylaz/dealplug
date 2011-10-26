set :application, "dealplug"
role :app, "dealplug.com"
role :web, "dealplug.com"
role :db,  "dealplug.com", :primary => true

set :scm, :git
set :repository, "git://github.com/greglazarev/dealplug.git"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/rails/#{application}"

set :user, "root"
set :use_sudo,     false

namespace :deploy do
  task :symlink do
    run "ln -nsf #{shared_path}/production.sqlite3 #{release_path}/db/production.sqlite3"
  end

  task :restart do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

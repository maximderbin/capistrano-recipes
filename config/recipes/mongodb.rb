# The installation adds a mongodb.conf to /etc/mongodb.conf.
# Use this file to further configure the MongoDB server. After you finish configuring MongoDB,
# you can either use Capistrano to restart the MongoDB server with `cap mongodb:restart`
# or on the server through SSH with `service mongodb restart`.

set_default(:mongodb_password) { Capistrano::CLI.password_prompt "MongoDB Password: " }

namespace :mongodb do
  after "deploy:install", "mongodb:install"
  desc "Install the latest stable release of MongoDB."
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} add-apt-repository 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen'"
    run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mongodb-10gen"
  end

  after "deploy:setup", "mongodb:setup"
  desc "Generate the mongoid.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "mongoid.yml.erb", "#{shared_path}/config/mongoid.yml"
  end

  after "deploy:finalize_update", "mongodb:symlink"
  desc "Symlink the mongoid.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  %w[start stop restart].each do |command|
    desc "#{command.capitalize} MongoDB server."
    task command do
      run "#{sudo} service mongodb #{command}"
    end
  end
end

# This hook removes default migration tasks, because mongoDB don't use it
namespace :deploy do
  # Removes deploy:cold callback
  callback = callbacks[:after].find{|c| c.source == "deploy:migrate" }
  callbacks[:after].delete(callback)
  # Rewrites migrate task to logger text
  task :migrate, roles: :db  do
    logger.info "deploy:migrate has been removed. Check config/recipes/mongodb.rb for details"
  end
  # Rewrites migrations task to logger text
  task :migrations, roles: :db  do
    logger.info "deploy:migrations task has been removed. Check config/recipes/mongodb.rb for details"
  end
end

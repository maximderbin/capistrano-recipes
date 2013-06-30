namespace :config do
  after "deploy:finalize_update", "config:symlink"
  desc "Symlink the application.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end

  after "deploy:setup", "config:upload"
  desc "Upload application.yml config to the server"
  task :upload do
    top.upload("config/application.yml", "#{shared_path}/config", via: :scp)
  end
end

require 'bundler/capistrano'
require 'capistrano_colors'

%w[base nodejs nginx unicorn assets mongodb callbacks].each do |recipe|
  load "config/recipes/#{recipe}"
end

# Servers and their roles.
server "111.111.111.111", :web, :app, :db, primary: true
set_default(:server_name, 'servername.ru')

# Server-side information.
set :user,        "user"
set :application, "appname"
set :deploy_to,   "/home/#{user}/#{application}"
set :use_sudo,    false

# Repository (if any) configuration.
set :scm,         :git
set :deploy_via,  :remote_cache
set :repository,  "git@github.com:user/repository.git"
set :branch,      "master"

# Run on Linux: `$ ssh-add` or on OSX: `$ ssh-add -K` for "forward_agent".
ssh_options[:forward_agent] = true
ssh_options[:port]          = 22
default_run_options[:pty]   = true

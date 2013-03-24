require 'bundler/capistrano'
require 'capistrano_colors'
#require 'delayed/recipes'

load 'config/recipes/base'
load 'config/recipes/nginx'
load 'config/recipes/nodejs'
load 'config/recipes/unicorn'
load 'config/recipes/assets'
load 'config/recipes/mongodb'
load 'config/recipes/callbacks'

server "111.111.111.111", :web, :app, :db, primary: true

set :user, "user"
set :application, "appname"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:user/repository.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set_default(:server_name, 'servername.ru')

after "deploy", "deploy:cleanup"

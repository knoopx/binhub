require 'capistrano_colors'
require 'bundler/capistrano'

set :application, "binhub"
set :repository,  "git://github.com/knoopx/binhub.git"

set :scm, :git
set :user, "deploy"
set :use_sudo, false
set :normalize_asset_timestamps, false

set :deploy_to, "~/#{application}"

server "raspberry-pi.local", :web, :app, :db

after "deploy:restart", "deploy:cleanup"
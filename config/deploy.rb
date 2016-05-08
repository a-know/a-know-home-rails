# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'a-know-home'
set :repo_url, 'git@github.com:a-know/a-know-home-rails.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/gg_svg', 'tmp/gg_others_svg', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :unicorn_roles, :web

namespace :deploy do
  # /var/www/a-know-home を掘るためのタスク
  task :setup_deploy_to do
    on roles(:web, :batch) do |host|
      if test("[ ! -d #{deploy_to} ]")
        sudo "install --owner=#{host.user} --mode=0755 -d #{deploy_to}"
      end
    end
  end
  before 'deploy:starting', 'deploy:setup_deploy_to'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :restart do
    on roles(:web), in: :groups, limit: 1, wait: 15 do
      invoke 'unicorn:restart'
    end
  end

end

after 'deploy:publishing', 'deploy:restart'

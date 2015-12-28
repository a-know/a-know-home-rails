ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :rails_env, :development
role :web,    %w{vagrant@vm-web}

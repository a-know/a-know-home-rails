ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :rails_env, :production
role :web,    %w{a-know@home.a-know.me}

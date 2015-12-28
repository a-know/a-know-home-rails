ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
role :web,    %w{vagrant@vm-web}

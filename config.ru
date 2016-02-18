# This file is used by Rack-based servers to start the application.

# Unicorn self-process killer
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096, true

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (128*(1024**2)), (192*(1024**2))

require ::File.expand_path('../config/environment', __FILE__)

# Action Cable uses EventMachine which requires that all classes are loaded in advance
Rails.application.eager_load!

run Rails.application

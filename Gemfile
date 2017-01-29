source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '>= 5.0.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# Use Puma as the app server
gem 'dotenv-rails'
gem 'exception_notification'
gem 'fitgem'
gem 'fluent-logger'
gem 'gcloud'
gem 'gio2'
gem 'gobject-introspection'
gem 'google-api-client', '~> 0.8.6'
gem 'ltsv_log_formatter'
gem 'mini_magick'
gem 'puma'
gem 'rack-heartbeat'
gem 'rsvg2'
gem 'slack-notifier'
gem 'unicorn'
gem 'unicorn-worker-killer'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development do
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'mackerel-client'
end

group :development, :test do
  gem 'annotate'
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'flay'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'metric_fu-Saikuro'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rails_best_practices'
  gem 'rspec-rails'
end

group :test do
  gem 'rspec-json_matcher'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'nokogiri', '>= 1.6.8'

gem 'rails-html-sanitizer', '~> 1.0.3'

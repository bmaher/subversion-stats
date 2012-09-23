source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'mysql2'
gem 'haml'
gem 'jquery-rails'
gem 'therubyracer'
gem 'will_paginate'
gem 'libxml-ruby'
gem 'newrelic_rpm'
gem 'sidekiq'
gem 'sinatra', :require => false
gem 'slim'
gem 'devise'
gem 'cancan'
gem 'open4'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
end

group :development do
  gem 'thin'
  gem 'annotate'
  gem 'capistrano'
  gem 'ruby-prof'
  gem 'growl'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-jasmine'
  gem 'guard-livereload'
  group :darwin do
    gem 'rb-fsevent', :require => false
  end
end

group :test do
  gem 'webrat'
  gem 'factory_girl_rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jasminerice'
end

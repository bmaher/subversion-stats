source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'mysql'
gem 'haml'
gem 'jquery-rails'
gem 'therubyracer'
gem 'will_paginate'
gem 'libxml-ruby'
gem 'newrelic_rpm'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

group :assets do
  gem 'sass-rails', :git => 'https://github.com/rails/sass-rails.git', :tag=> '3-1-stable'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier',     '>= 1.0.3'
end

group :development do
  gem 'thin'
  gem 'annotate'
  gem 'capistrano'
  gem 'growl'
  gem 'growl_notify'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-jasmine'
  gem 'guard-livereload'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
end

group :test do
  gem 'ruby-prof'
  gem 'turn', '0.8.2', :require => false
  gem 'webrat'
  gem 'factory_girl_rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jasminerice'
end

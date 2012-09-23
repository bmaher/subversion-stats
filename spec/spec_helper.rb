require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'sidekiq'
  require 'sidekiq/testing'
  require 'sidekiq/testing/inline'

  counter = -1
  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.filter_run_excluding :broken_in_spork => false

    # Disabling garbage collection (will run every 10 specs to free memory)
    config.after(:each) do
      counter += 1
      if counter > 9
        GC.enable
        GC.start
        GC.disable
        counter = 0
      end
    end

    config.after(:suite) do
      counter = 0
    end
  end
end

Spork.each_run do
  GC.disable
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
end

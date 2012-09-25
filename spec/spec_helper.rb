ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Rails.logger = Logger.new('/dev/null')

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include(FactoryGirl::Syntax::Methods)

  config.before(:all) { silence_stream(STDOUT) { load Rails.root.join("db/schema.rb") } }

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end


ENV['RAILS_ENV'] ||= 'test'

require 'factory_girl'
require 'database_cleaner'
require 'engine_cart'
require 'coveralls'
Coveralls.wear!('rails')
EngineCart.load_application!

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  options = {}

  options[:timeout] = 120 if RUBY_PLATFORM == 'java'

  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.default_wait_time = 15

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'geoblacklight'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before :each do
    DatabaseCleaner.strategy = if Capybara.current_driver == :rack_test
                                 :transaction
                               else
                                 :truncation
                               end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
end

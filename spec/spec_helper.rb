ENV['RAILS_ENV'] ||= 'test'

require 'factory_girl'
require 'database_cleaner'
require 'engine_cart'
require 'coveralls'
Coveralls.wear!('rails')
EngineCart.load_application!

require 'rails-controller-testing' if Rails::VERSION::MAJOR >= 5
require 'rspec/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu no-sandbox window-size=1280,1024) }
  )

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities)
end

Capybara.javascript_driver = :headless_chrome

Capybara.default_max_wait_time = 15

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'geoblacklight'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryBot.find_definitions

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
  if Rails::VERSION::MAJOR >= 5
    config.include ::Rails.application.routes.url_helpers
    config.include ::Rails.application.routes.mounted_helpers
  else
    config.include BackportTestHelpers, type: :controller
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
end

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
)
SimpleCov.start 'rails' do
  add_filter 'lib/generators/geoblacklight/install_generator.rb'
  add_filter 'lib/geoblacklight/version.rb'
  add_filter 'lib/generators/geoblacklight/templates'
  add_filter '/spec'
  add_filter '.internal_test_app/'
end

require 'factory_bot'
require 'database_cleaner'

require 'engine_cart'
EngineCart.load_application!

require 'rails-controller-testing' if Rails::VERSION::MAJOR >= 5
require 'rspec/rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'webdrivers'

Capybara.register_driver(:headless_chrome) do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--disable-gpu'
    opts.args << '--window-size=1280,1024'
  end
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.read_timeout = 120
  http_client.open_timeout = 120
  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 http_client: http_client,
                                 options: browser_options)
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 120

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

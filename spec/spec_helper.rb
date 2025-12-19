# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

if ENV.fetch("CIRCLE_ARTIFACTS", false)
  dir = File.join(ENV.fetch("CIRCLE_ARTIFACTS"), "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start "rails" do
  add_filter "app/components/blacklight/icons"
  add_filter "lib/generators/geoblacklight/install_generator.rb"
  add_filter "lib/geoblacklight/version.rb"
  add_filter "lib/geoblacklight/engine.rb"
  add_filter "lib/generators"
  add_filter "lib/tasks/geoblacklight.rake"
  add_filter "/spec"
  add_filter ".internal_test_app/"
  minimum_coverage 100
end

require "database_cleaner"
require "action_cable/engine"
require "engine_cart"
require "factory_bot"
EngineCart.load_application!

require "rails-controller-testing" if Rails::VERSION::MAJOR >= 5
require "rspec/rails"
require "capybara/rspec"
require "selenium-webdriver"

# Setup webmock for specific tests
require "webmock/rspec"
WebMock.allow_net_connect!(net_http_connect_on_start: true)

Capybara.register_driver :chrome_headless do |app|
  # Set up Chrome options
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--disable-gpu")
  options.add_argument("--no-sandbox")
  options.add_argument("--window-size=1280,1024")

  # Allow longer TCP reads to prevent timeout in the case of loading fixture
  # eee6150b-ce2f-4837-9d17-ce72a0c1c26f, as part of relations_spec.rb
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120 # seconds

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, http_client: client)
end

Capybara.javascript_driver = :chrome_headless

require "geoblacklight"

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

FactoryBot.definition_file_paths = [File.expand_path("factories", __dir__)]
FactoryBot.find_definitions

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  if Rails::VERSION::MAJOR >= 5
    config.include ::Rails.application.routes.url_helpers
    config.include ::Rails.application.routes.mounted_helpers
  else
    config.include BackportTestHelpers, type: :controller
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponentCapybaraTestHelpers, type: :component
end

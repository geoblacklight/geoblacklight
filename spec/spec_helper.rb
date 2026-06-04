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

require "billy/capybara/rspec"

# Setup webmock for specific tests
require "webmock/rspec"
WebMock.allow_net_connect!(net_http_connect_on_start: true)

# Configure Billy
Billy.configure do |c|
  c.cache = true
  c.cache_path = "spec/fixtures/billy"
  c.persist_cache = true
  # Add domains that should not be cached or should be allowed
  c.whitelist = [
    "127.0.0.1",
    "localhost",
    /.*esm\.sh/,
    /.*cdn\.jsdelivr\.net/,
    /.*cdn\.skypack\.dev/,
    /.*ga\.jspm\.io/,
    /.*unpkg\.com/,
    /.*googleapis\.com/,
    /.*google\.com/,
    /.*cloudflare\.com/,
    /.*edgedl\.me\.gvt1\.com/,
    /.*googletagmanager\.com/,
    /.*honeybadger\.io/,
    /.*stanford\.edu/,
    /.*openstreetmap\.org/,
    /.*openstreetmap\.fr/
  ]
end

Capybara.default_max_wait_time = 15

Capybara.register_driver :chrome_headless_billy do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # options.add_argument("--headless")
  options.add_argument("--disable-gpu")
  options.add_argument("--no-sandbox")
  options.add_argument("--window-size=1280,1024")
  options.add_argument("--proxy-server=#{Billy.proxy.host}:#{Billy.proxy.port}")
  options.add_argument("--ignore-certificate-errors")

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 60

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, http_client: client)
end

Capybara.javascript_driver = :chrome_headless_billy

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

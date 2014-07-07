ENV["RAILS_ENV"] ||= 'test'

require 'engine_cart'
EngineCart.load_application!

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  options = {}

  options[:timeout] = 120 if RUBY_PLATFORM == "java"

  Capybara::Poltergeist::Driver.new(app, options)
end

if ENV["COVERAGE"] or ENV["CI"]
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter "/spec/"
  end
end


require 'geoblacklight'

require 'rspec/rails'
require 'capybara/rspec'


RSpec.configure do |config|

end

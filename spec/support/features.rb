# frozen_string_literal: true

require File.expand_path("../features/session_helpers.rb", __FILE__)

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end

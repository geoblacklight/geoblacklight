# frozen_string_literal: true

require File.expand_path("../features/session_helpers.rb", __FILE__)
require File.expand_path("../features/map_helpers.rb", __FILE__)
require File.expand_path("../features/viewer_helpers.rb", __FILE__)

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::MapHelpers, type: :feature
  config.include Features::ViewerHelpers, type: :feature
end

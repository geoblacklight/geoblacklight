# frozen_string_literal: true

require "active_support/deprecation"

module Geoblacklight
  Deprecation = ActiveSupport::Deprecation.new("7.0", "GeoBlacklight")
end

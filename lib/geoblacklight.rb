# frozen_string_literal: true

require "active_support/dependencies"
require "active_support/deprecation"
require "geoblacklight/engine"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.collapse("#{__dir__}/geoblacklight/download")
loader.collapse("#{__dir__}/geoblacklight/wms_layer")
loader.setup

module Geoblacklight
  def self.logger
    ::Rails.logger
  end

  # Deprecator for GeoBlacklight's own deprecations. Anything deprecated here is
  # slated for removal in GeoBlacklight 6.0.
  #
  # Downstream applications can configure its behavior the same way they would any
  # other Rails deprecator, e.g. in config/application.rb:
  #
  #   config.active_support.deprecation = :raise
  #
  # or directly:
  #
  #   Geoblacklight.deprecation.behavior = :silence
  def self.deprecation
    @deprecation ||= ActiveSupport::Deprecation.new("6.0", "GeoBlacklight")
  end
end

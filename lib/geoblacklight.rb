# frozen_string_literal: true

require "active_support/dependencies"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.collapse("#{__dir__}/geoblacklight/download")
loader.collapse("#{__dir__}/geoblacklight/wms_layer")
loader.setup
require "geoblacklight/engine"

module Geoblacklight
  def self.logger
    ::Rails.logger
  end

  mattr_accessor :configuration_builder, default: Geoblacklight::Configuration::LegacySettingsBuilder

  def self.configuration
    @configuration ||= configuration_builder.build
  end
end

# frozen_string_literal: true

require "active_support/dependencies"
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
end

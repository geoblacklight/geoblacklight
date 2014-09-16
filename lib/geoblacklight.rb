require "geoblacklight/engine"

module Geoblacklight
  require 'geoblacklight/config'
  require 'geoblacklight/controller_override'
  def self.inject!
    CatalogController.send(:include, Geoblacklight::ControllerOverride)
  end
end

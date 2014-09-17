require "geoblacklight/engine"

module Geoblacklight
  require 'geoblacklight/config'
  require 'geoblacklight/controller_override'
  require 'geoblacklight/view_helper_override'
  def self.inject!
    CatalogController.send(:include, Geoblacklight::ControllerOverride)
    CatalogController.send(:include, Geoblacklight::ViewHelperOverride)
    SearchHistoryController.send(:helper, Geoblacklight::ViewHelperOverride) unless
      SearchHistoryController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
  end
end

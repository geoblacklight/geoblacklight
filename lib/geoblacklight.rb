require "geoblacklight/engine"

module Geoblacklight
  require 'geoblacklight/config'
  require 'geoblacklight/constants'
  require 'geoblacklight/controller_override'
  require 'geoblacklight/view_helper_override'
  require 'geoblacklight/solr_document'
  require 'geoblacklight/wms_layer'
  require 'geoblacklight/download'
  require 'geoblacklight/download/shapefile_download'
  require 'geoblacklight/download/kmz_download'
  require 'geoblacklight/reference'
  require 'geoblacklight/references'
  def self.inject!
    CatalogController.send(:include, Geoblacklight::ControllerOverride)
    CatalogController.send(:include, Geoblacklight::ViewHelperOverride)
    CatalogController.send(:helper, Geoblacklight::ViewHelperOverride) unless
      CatalogController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
    SearchHistoryController.send(:helper, Geoblacklight::ViewHelperOverride) unless
      SearchHistoryController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
  end
end

require "geoblacklight/engine"

module Geoblacklight
  require 'geoblacklight/config'
  require 'geoblacklight/constants'
  require 'geoblacklight/controller_override'
  require 'geoblacklight/exceptions'
  require 'geoblacklight/view_helper_override'
  require 'geoblacklight/item_viewer'
  require 'geoblacklight/solr_document'
  require 'geoblacklight/wms_layer'
  require 'geoblacklight/download'
  require 'geoblacklight/download/geojson_download'
  require 'geoblacklight/download/geotiff_download'
  require 'geoblacklight/download/kmz_download'
  require 'geoblacklight/download/shapefile_download'
  require 'geoblacklight/download/hgl_download'
  require 'geoblacklight/reference'
  require 'geoblacklight/references'
  def self.inject!
    CatalogController.send(:include, Geoblacklight::ControllerOverride)
    CatalogController.send(:include, Geoblacklight::ViewHelperOverride)
    CatalogController.send(:helper, Geoblacklight::ViewHelperOverride) unless
      CatalogController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
    SearchHistoryController.send(:helper, Geoblacklight::ViewHelperOverride) unless
      SearchHistoryController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
    SavedSearchesController.send(:helper, Geoblacklight::ViewHelperOverride) unless
      SavedSearchesController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
  end

  def self.logger
    ::Rails.logger
  end
end

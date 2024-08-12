# frozen_string_literal: true

require "active_support/dependencies"
require "geoblacklight/engine"

module Geoblacklight
  require "geoblacklight/bounding_box"
  require "geoblacklight/constants"
  require "geoblacklight/exceptions"
  require "geoblacklight/geometry"
  require "geoblacklight/view_helper_override"
  require "geoblacklight/item_viewer"
  require "geoblacklight/wms_layer"
  require "geoblacklight/wms_layer/feature_info_response"
  require "geoblacklight/download"
  require "geoblacklight/download/geojson_download"
  require "geoblacklight/download/geotiff_download"
  require "geoblacklight/download/kmz_download"
  require "geoblacklight/download/shapefile_download"
  require "geoblacklight/metadata"
  require "geoblacklight/metadata/base"
  require "geoblacklight/metadata/fgdc"
  require "geoblacklight/metadata/html"
  require "geoblacklight/metadata/iso19139"
  require "geoblacklight/metadata_transformer"
  require "geoblacklight/metadata_transformer/base"
  require "geoblacklight/metadata_transformer/fgdc"
  require "geoblacklight/metadata_transformer/iso19139"
  require "geoblacklight/reference"
  require "geoblacklight/references"
  require "geoblacklight/routes"
  require "geoblacklight/relation/descendants"
  require "geoblacklight/relation/ancestors"
  require "geoblacklight/relation/relation_response"

  def self.logger
    ::Rails.logger
  end
end

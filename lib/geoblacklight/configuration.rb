module Geoblacklight
  # Configuration for Geoblacklight
  class Configuration
    include ActiveModel::Attributes

    # ArcGIS Online Base URL
    attribute :arcgis_base_url, :string, default: "https://www.arcgis.com/apps/mapviewer/index.html"

    # The bq boost value for spatial search matches within a bounding box
    attribute :bbox_within_boost, :string, default: "10"

    # The bf boost value for overlap ratio
    attribute :overlap_ratio_boost, :string, default: "2"

    # Institution deployed at
    attribute :institution, :string, default: "Stanford"

    # (For external Download) timeout and open_timeout parameters for Faraday
    attribute :timeout_download, :integer, default: 180

    # (For WMS inspection) timeout and open_timeout parameters for Faraday
    attribute :timeout_wms, :integer, default: 4

    # Display Notes to display / Non-prefixed default bootstrap class is alert-secondary
    attr_accessor :display_notes_shown # typed as Hash

    # Toggle the help text feature that offers users context
    attr_accessor :help_text # typed as Hash

    # Non-search-field GeoBlacklight application permitted params
    attr_accessor :gbl_params # typed as Array

    # WMS Parameters
    attr_accessor :wms_params # typed as Hash

    # Enable catalog#show sidebar static map for items with the following viewer protocols
    attr_accessor :sidebar_static_map # typed as Array

    attribute :iiif_drag_drop_link, :string, default: "@manifest?manifest=@manifest"

    # Homepage Map Geometry
    # Leave null to default to entire world
    # Add a stringified GeoJSON object to scope initial render (example from UMass)
    #   config.homepage_map_geom = '{"type":"Polygon","coordinates":[[[-73.58,42.93],[-73.58,41.20],[-69.90,41.20],[-69.90,42.93]]]}'
    attribute :homepage_map_geom, :string

    # Vector data download formats to be displayed
    attr_accessor :vector_download_formats  # typed as Array

    # Metadata shown in tool panel
    attr_accessor :metadata_shown # typed as Array

    # Web services shown in tool panel
    attr_accessor :webservices_shown # typed as Array

    # Relationships to display
    attr_accessor :relationships_shown # typed as RelationshipsConfig

    attribute :download_path, :string

    def initialize
      super
      self.download_path ||= Rails.root.join("tmp", "cache", "downloads")
      @relationships_shown = RelationshipsConfig.new
      @gbl_params = [
        :bbox, :email, :file, :format, :id, :logo, :provider, :type,
        :BBOX, :HEIGHT, :LAYERS, :QUERY_LAYERS, :URL, :WIDTH, :X, :Y
      ]
      @wms_params = {
        SERVICE: "WMS",
        VERSION: "1.1.1",
        REQUEST: "GetFeatureInfo",
        STYLES: "",
        SRS: "EPSG:4326",
        EXCEPTIONS: "application/json",
        INFO_FORMAT: "application/json"
      }
      @help_text = {
        viewer_protocol: %w[
          cog
          dynamic_map_layer
          feature_layer
          iiif
          iiif_manifest
          image_map_layer
          index_map
          oembed
          pmtiles
          tiled_map_layer
          tilejson
          tms
          wms
          wmts
          xyz
        ]
      }

      @vector_download_formats = ["Shapefile", "KMZ", "GeoJSON", "CSV"]
      @metadata_shown = ["mods", "fgdc", "iso19139", "html"]
      @webservices_shown = %w[
        wms
        tms
        wfs
        xyz
        wmts
        tilejson
        iiif
        feature_layer
        tiled_map_layer
        dynamic_map_layer
        image_map_layer
        cog
        pmtiles
      ]

      @display_notes_shown = {
        danger: DisplayNoteShownConfig.new(
          bootstrap_alert_class: "alert-danger",
          icon: "fire-solid",
          note_prefix: "Danger: "
        ),
        info: DisplayNoteShownConfig.new(
          bootstrap_alert_class: "alert-info",
          icon: "circle-info-solid",
          note_prefix: "Info: "
        ),
        tip: DisplayNoteShownConfig.new(
          bootstrap_alert_class: "alert-success",
          icon: "lightbulb-solid",
          note_prefix: "Tip: "
        ),
        warning: DisplayNoteShownConfig.new(
          bootstrap_alert_class: "alert-warning",
          icon: "triangle-exclamation-solid",
          note_prefix: "Warning: "
        )
      }

      @sidebar_static_map = ["iiif", "iiif_manifest"]
    end

    def fields
      @fields ||= FieldsConfig.new
    end

    ##
    # Returns Leaflet plugin settings to pass to the viewer.
    # @return[Geoblacklight::Configuration::LeafletConfig]
    def leaflet_options
      @leaflet_options ||= Geoblacklight::Configuration::LeafletConfig.new
    end
  end
end

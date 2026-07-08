# frozen_string_literal: true

module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionality
  module SolrDocument
    extend Blacklight::Solr::Document
    extend ActiveSupport::Concern
    include Geoblacklight::SolrDocument::Finder
    include Geoblacklight::SolrDocument::Inspection
    include Geoblacklight::SolrDocument::Arcgis
    include Geoblacklight::SolrDocument::Citation

    delegate :viewer_protocol, to: :item_viewer
    delegate :viewer_endpoint, to: :item_viewer

    included do
      field_config = Geoblacklight.configuration.fields
      attribute :display_note, :array, field_config.display_note
      attribute :geom_field, :string, field_config.geometry
      attribute :wxs_identifier, :string, field_config.wxs_identifier
      attribute :file_format, :string, field_config.format
      attribute :rights_field_data, :string, field_config.access_rights
      attribute :provider, :string, field_config.provider
      attribute :resource_type, :array, field_config.resource_type
      attribute :resource_class, :array, field_config.resource_class
      attribute :title, :string, field_config.title
      attribute :creator, :array, field_config.creator
      attribute :publisher, :string, field_config.publisher
      attribute :identifiers, :array, field_config.identifier
      attribute :issued, :string, field_config.date_issued
      attribute :format, :string, field_config.format
    end

    def available?
      public? || same_institution?
    end

    def public?
      rights_field_data&.casecmp?("public")
    end

    def restricted?
      !rights_field_data || rights_field_data.casecmp?("restricted")
    end

    def downloadable?
      (direct_download || iiif_download) && available?
    end

    def references
      References.new(self)
    end

    def direct_download
      references.download.to_hash if references.download.present?
    end

    def oembed
      references.oembed.endpoint if references.oembed.present?
    end

    def same_institution?
      provider&.casecmp?(Geoblacklight.configuration.institution.downcase)
    end

    def iiif_download
      references.iiif.to_hash if references.iiif.present?
    end

    def data_dictionary_download
      references.data_dictionary.to_hash if references.data_dictionary.present?
    end

    def external_url
      references.url&.endpoint
    end

    def item_viewer
      ItemViewer.new(references)
    end

    def itemtype
      "http://schema.org/Dataset"
    end

    def geometry
      @geometry ||= Geoblacklight::Geometry.new(geom_field)
    end
  end
end

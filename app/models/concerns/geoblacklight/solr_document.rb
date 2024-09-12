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

    delegate :download_types, to: :references
    delegate :viewer_protocol, to: :item_viewer
    delegate :viewer_endpoint, to: :item_viewer

    included do
      attribute :display_note, :array, Settings.FIELDS.DISPLAY_NOTE
      attribute :geom_field, :string, Settings.FIELDS.GEOMETRY
      attribute :wxs_identifier, :string, Settings.FIELDS.WXS_IDENTIFIER
      attribute :file_format, :string, Settings.FIELDS.FORMAT
      attribute :rights_field_data, :string, Settings.FIELDS.ACCESS_RIGHTS
      attribute :provider, :string, Settings.FIELDS.PROVIDER
      attribute :resource_type, :array, Settings.FIELDS.RESOURCE_TYPE
      attribute :resource_class, :array, Settings.FIELDS.RESOURCE_CLASS
      attribute :title, :string, Settings.FIELDS.TITLE
      attribute :creator, :array, Settings.FIELDS.CREATOR
      attribute :publisher, :string, Settings.FIELDS.PUBLISHER
      attribute :identifiers, :array, Settings.FIELDS.IDENTIFIER
      attribute :issued, :string, Settings.FIELDS.DATE_ISSUED
      attribute :format, :string, Settings.FIELDS.FORMAT
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
      (direct_download || download_types.present? || iiif_download) && available?
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
      provider&.casecmp?(Settings.INSTITUTION.downcase)
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

    ##
    # Provides a convenience method to access a SolrDocument's References
    # endpoint url without having to check and see if it is available
    # :type => a string which if its a Geoblacklight::Constants::URI key
    #          will return a coresponding Geoblacklight::Reference
    def checked_endpoint(type)
      type = references.public_send(type)
      type.endpoint if type.present?
    end

    private

    def method_missing(method, *args, &block)
      if /.*_url$/.match?(method.to_s)
        checked_endpoint(method.to_s.gsub("_url", ""))
      else
        super
      end
    end

    def respond_to_missing?(method, *args, &block)
      /.*_url$/.match?(method.to_s) || super
    end
  end
end

# frozen_string_literal: true

module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionality
  module SolrDocument
    extend Blacklight::Solr::Document

    include Geoblacklight::SolrDocument::Finder
    include Geoblacklight::SolrDocument::Carto
    include Geoblacklight::SolrDocument::Inspection
    include Geoblacklight::SolrDocument::Arcgis
    include Geoblacklight::SolrDocument::Citation

    delegate :download_types, to: :references
    delegate :viewer_protocol, to: :item_viewer
    delegate :viewer_endpoint, to: :item_viewer

    def available?
      public? || same_institution?
    end

    def public?
      rights_field_data.present? && rights_field_data.casecmp("public").zero?
    end

    def restricted?
      if key?(Settings.FIELDS.ACCESS_RIGHTS) && self[Settings.FIELDS.ACCESS_RIGHTS].blank?
        Geoblacklight.deprecation.warn(
          "Geoblacklight::SolrDocument#restricted? returns true for a document whose " \
          "#{Settings.FIELDS.ACCESS_RIGHTS} is present but blank; GeoBlacklight 5 returns false for the " \
          "same document, because it tests the value for nil rather than for blankness"
        )
      end
      rights_field_data.blank? || rights_field_data.casecmp("restricted").zero?
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

    def display_note
      fetch(Settings.FIELDS.DISPLAY_NOTE, "")
    end

    # @deprecated
    def hgl_download
      Geoblacklight.deprecation.silence do
        references.hgl.to_hash if references.hgl.present?
      end
    end
    Geoblacklight.deprecation.deprecate_methods(Geoblacklight::SolrDocument,
      hgl_download: "the Harvard Geospatial Library download integration is removed without replacement in GeoBlacklight 5")

    def oembed
      references.oembed.endpoint if references.oembed.present?
    end

    def same_institution?
      fetch(Settings.FIELDS.PROVIDER, "").casecmp(Settings.INSTITUTION.downcase).zero?
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

    def geom_field
      warn_about_blank_default(Settings.FIELDS.GEOMETRY, "geom_field")
      fetch(Settings.FIELDS.GEOMETRY, "")
    end

    def geometry
      @geometry ||= Geoblacklight::Geometry.new(Geoblacklight.deprecation.silence { geom_field })
    end

    def wxs_identifier
      warn_about_blank_default(Settings.FIELDS.WXS_IDENTIFIER, "wxs_identifier")
      fetch(Settings.FIELDS.WXS_IDENTIFIER, "")
    end

    def file_format
      fetch(Settings.FIELDS.FORMAT)
    end

    ##
    # Provides a convenience method to access a SolrDocument's References
    # endpoint url without having to check and see if it is available
    # :type => a string which if its a Geoblacklight::Constants::URI key
    #          will return a coresponding Geoblacklight::Reference
    def checked_endpoint(type)
      type = references.send(type)
      type.endpoint if type.present?
    end

    private

    ##
    # In GeoBlacklight 5 these readers are Blacklight `attribute` declarations, which
    # return nil rather than "" when the Solr field is missing.
    # @param field [String] the Solr field backing the reader
    # @param reader [String] the name of the reader, for the warning
    def warn_about_blank_default(field, reader)
      return if key?(field)

      Geoblacklight.deprecation.warn(
        "Geoblacklight::SolrDocument##{reader} returns \"\" for a document with no #{field}; " \
        "GeoBlacklight 5 returns nil instead, so calls like ##{reader}.empty? or ##{reader}.split will raise"
      )
    end

    def rights_field_data
      fetch(Settings.FIELDS.ACCESS_RIGHTS, "")
    end

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

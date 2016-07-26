module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionalit
  module SolrDocument
    extend Blacklight::Solr::Document

    include Geoblacklight::SolrDocument::Finder
    include Geoblacklight::SolrDocument::CartoDb
    include Geoblacklight::SolrDocument::Inspection

    delegate :download_types, to: :references
    delegate :viewer_protocol, to: :item_viewer
    delegate :viewer_endpoint, to: :item_viewer

    def available?
      public? || same_institution?
    end

    def public?
      fetch(Settings.FIELDS.RIGHTS).casecmp('public').zero?
    end

    def restricted?
      fetch(Settings.FIELDS.RIGHTS).casecmp('restricted').zero?
    end

    def downloadable?
      (direct_download || download_types.present? || iiif_download) && available?
    end

    def references
      References.new(self)
    end

    def direct_download
      return references.download.to_hash unless references.download.blank?
    end

    def hgl_download
      return references.hgl.to_hash unless references.hgl.blank?
    end

    def same_institution?
      fetch(Settings.FIELDS.PROVENANCE).casecmp(Settings.INSTITUTION.downcase).zero?
    end

    def iiif_download
      return references.iiif.to_hash unless references.iiif.blank?
    end

    def item_viewer
      ItemViewer.new(references)
    end

    def itemtype
      'http://schema.org/Dataset'
    end

    def bounding_box_as_wsen
      geom_field = fetch(Settings.FIELDS.GEOMETRY)
      exp = /^\s*ENVELOPE\(
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*
                  \)\s*$/x # uses 'x' option for free-spacing mode
      bbox_match = exp.match(geom_field)
      return s unless bbox_match # return as-is, not a WKT
      w, e, n, s = bbox_match.captures
      "#{w} #{s} #{e} #{n}"
    end

    def wxs_identifier
      fetch(Settings.FIELDS.WXS_IDENTIFIER)
    end

    def file_format
      fetch(Settings.FIELDS.FILE_FORMAT)
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

    def method_missing(method, *args, &block)
      if /.*_url$/ =~ method.to_s
        checked_endpoint(method.to_s.gsub('_url', ''))
      else
        super
      end
    end
  end
end

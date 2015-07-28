module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionalit
  module SolrDocument
    extend Blacklight::Solr::Document

    include Geoblacklight::SolrDocument::Finder
    include Geoblacklight::SolrDocument::Inspection

    delegate :download_types, to: :references
    delegate :viewer_protocol, to: :item_viewer
    delegate :viewer_endpoint, to: :item_viewer

    def available?
      public? || same_institution?
    end

    def public?
      fetch(:dc_rights_s).downcase == 'public'
    end

    def restricted?
      fetch(:dc_rights_s).downcase == 'restricted'
    end

    def downloadable?
      (direct_download || download_types.present?) && available?
    end

    def download_types
      references.download_types
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
      fetch(:dct_provenance_s).downcase == Settings.INSTITUTION.downcase
    end

    def item_viewer
      ItemViewer.new(references)
    end

    def itemtype
      "http://schema.org/Dataset"
    end

    def bounding_box_as_wsen
      s = fetch(Settings.GEOMETRY_FIELD.to_sym)
      if s =~ /^\s*ENVELOPE\(\s*([-\.\d]+)\s*,\s*([-\.\d]+)\s*,\s*([-\.\d]+)\s*,\s*([-\.\d]+)\s*\)\s*$/
        w, s, e, n = $1, $4, $2, $3
        return "#{w} #{s} #{e} #{n}"
      else
        return s # as-is, not a WKT
      end
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

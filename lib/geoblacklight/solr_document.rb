module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionalit
  module SolrDocument
    extend Blacklight::Solr::Document

    def available?
      public? || same_institution?
    end

    def public?
      get(:dc_rights_s).downcase == 'public'
    end

    def restricted?
      get(:dc_rights_s).downcase == 'restricted'
    end

    def downloadable?
      get(:solr_wfs_url) && get(:solr_wms_url) && available?
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

    def same_institution?
      get(:dct_provenance_s).downcase == Settings.INSTITUTION.downcase
    end

    def itemtype
      "http://schema.org/Dataset"
    end
  end
end

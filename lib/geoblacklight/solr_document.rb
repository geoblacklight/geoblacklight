module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionalit
  module SolrDocument
    extend Blacklight::Solr::Document

    def available?
      public? || same_institution?
    end

    def public?
      get(:dc_rights_s) == 'Public'
    end

    def downloadable?
      get(:solr_wfs_url) && get(:solr_wms_url) && available?
    end

    def download_types
      [{ label: 'Shapefile', type: 'shapefile' }, { label: 'KMZ', type: 'kmz' }]
    end

    def same_institution?
      get(:dct_provenance_s) == Settings.Institution
    end

    def itemtype
      "http://schema.org/Dataset"
    end
  end
end

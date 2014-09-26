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

    def same_institution?
      get(:dct_provenance_s) == Settings.Institution
    end
  end
end

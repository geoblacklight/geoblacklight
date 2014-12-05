module Geoblacklight
  # Extends Blacklight::Solr::Document for GeoBlacklight specific functionalit
  module SolrDocument
    extend Blacklight::Solr::Document

    delegate :download_types, to: :references

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
      download_types.present? && available?
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

# frozen_string_literal: true
module Geoblacklight
  module SolrDocument
    ##
    # Finder methods for SolrDocuments
    # modeled after Spotlight's Finder module
    # https://github.com/sul-dlss/spotlight/blob/master/app/models/concerns/spotlight/solr_document/finder.rb
    module Finder
      extend ActiveSupport::Concern
      include Blacklight::Configurable

      ##
      # Class level finder methods for documents
      module ClassMethods
        ##
        # Find a Solr Document from an index
        # @param [String]
        def find(id)
          solr_response = index.find(id)
          solr_response.documents.first
        end

        def index
          @index ||= blacklight_config.repository_class.new(blacklight_config)
        end

        protected

        def blacklight_config
          @conf ||= copy_blacklight_config_from(CatalogController)
        end
      end

      def blacklight_solr
        self.class.index.connection
      end
    end
  end
end

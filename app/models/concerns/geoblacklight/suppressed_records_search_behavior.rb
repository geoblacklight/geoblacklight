# frozen_string_literal: true

module Geoblacklight
  module SuppressedRecordsSearchBehavior
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:hide_suppressed_records]
    end

    ##
    # Hide suppressed records in search
    # @param [Blacklight::Solr::Request]
    # @return [Blacklight::Solr::Request]
    def hide_suppressed_records(solr_params)
      # Show suppressed records when searching relationships
      return if blacklight_params.fetch(:f,
        {}).keys.any? do |field|
                  Geoblacklight.configuration.relationships_shown.map do |_key, value|
                    value.field
                  end.include?(field)
                end

      # Do not suppress action_documents method calls for individual documents
      # ex. CatalogController#web_services (exportable views)
      return if solr_params[:q]&.include?("{!lucene}#{Geoblacklight.configuration.fields.ID}:")

      solr_params[:fq] ||= []
      solr_params[:fq] << "-#{Geoblacklight.configuration.fields.SUPPRESSED}: true"
    end
  end
end

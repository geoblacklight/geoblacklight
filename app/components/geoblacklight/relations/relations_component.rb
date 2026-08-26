# frozen_string_literal: true

module Geoblacklight
  module Relations
    # Display links to records related to this one
    class RelationsComponent < ViewComponent::Base
      attr_reader :relationship_type, :rel_type_info

      def initialize(relations:, relationship_type:, rel_type_info:)
        @relations = relations
        @relationship_type = relationship_type
        @rel_type_info = rel_type_info
        super()
      end

      def render?
        result_count.positive?
      end

      def result_count
        response["numFound"].to_i
      end

      def related_docs
        @related_docs ||= Array(response["docs"]).map { |hash| ::SolrDocument.new(hash) }
      end

      def browse_all_path
        helpers.search_catalog_path({f: {configuration.field => [@relations.link_id]}})
      end

      # @param [SolrDocument] document an ancestor of the current document
      # @return [Integer, nil] how many documents in total - including the current one,
      #   which is always among them, since that's how this ancestor was found in the
      #   first place - share this ancestor.
      def sibling_count(document)
        return unless configuration.query_type == "ancestors"

        Geoblacklight::Relations::Descendants.new(RSolr.solr_escape(document.id), configuration.field, @relations.repository).results["numFound"].to_i
      end

      # @return [String] locale key under geoblacklight.relations.browse, e.g. "part_of"
      #   for both the "part_of_ancestors" and "part_of_descendants" relationship_type
      def browse_label_key
        relationship_type.to_s.sub(/_(ancestors|descendants)\z/, "")
      end

      private

      def configuration
        Geoblacklight.configuration.relationships_shown.public_send(relationship_type)
      end

      def response
        @response ||= @relations.public_send(relationship_type) || {}
      end
    end
  end
end

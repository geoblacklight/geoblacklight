# frozen_string_literal: true

module Geoblacklight
  module Relation
    class RelationResponse
      attr_reader :search_id, :link_id
      def initialize(id, repository)
        @link_id = id
        @search_id = RSolr.solr_escape(id)
        @repository = repository
      end

      def method_missing(method, *args, &block)
        if Settings.RELATIONSHIPS_SHOWN.key?(method)
          field = Settings.RELATIONSHIPS_SHOWN[method].field
          query_type = query_type(Settings.RELATIONSHIPS_SHOWN[method])
          @results = query_type.new(@search_id, field, @repository).results
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args)
        Settings.RELATIONSHIPS_SHOWN.key?(method_name) or super
      end

      private

      def query_type(option)
        case option.query_type
        when "ancestors"
          Geoblacklight::Relation::Ancestors
        when "descendants"
          Geoblacklight::Relation::Descendants
        else
          fail ArgumentError, "Bad RelationResponse query_type: #{option.query_type}. Only 'ancestors' or 'descendants' is allowed."
        end
      end
    end
  end
end

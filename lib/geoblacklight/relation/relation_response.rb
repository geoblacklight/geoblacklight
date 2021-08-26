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

      def ancestors(field = Settings.FIELDS.SOURCE)
        @ancestors ||= Geoblacklight::Relation::Ancestors.new(@search_id, field, @repository).results
      end

      def descendants(field = Settings.FIELDS.SOURCE)
        @descendants ||= Geoblacklight::Relation::Descendants.new(@search_id, field, @repository).results
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

      def empty?
        !(ancestors['numFound'].positive? || descendants['numFound'].positive?)
      end

      private

      def query_type(option)
        case option.query_type
        when 'ancestors'
          Geoblacklight::Relation::Ancestors
        when 'descendants'
          Geoblacklight::Relation::Descendants
        else
          fail NoMethodError
        end
      end
    end
  end
end

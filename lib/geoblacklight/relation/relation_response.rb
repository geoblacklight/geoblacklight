module Geoblacklight
  module Relation
    class RelationResponse
      attr_reader :id
      def initialize(id, repository)
        @search_id = id
        @repository = repository
      end

      def ancestors
        Geoblacklight::Relation::Ancestors.new(@search_id, @repository).results
      end

      def descendants
        Geoblacklight::Relation::Descendants.new(@search_id, @repository).results
      end

      def empty?
        !(ancestors['numFound'] > 0 || descendants['numFound'] > 0)
      end
    end
  end
end

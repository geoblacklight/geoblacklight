module Geoblacklight
  module Relation
    class RelationResponse
      attr_reader :relations
      def initialize(id, repository)
        @search_id = id
        @repository = repository
        @relations = {
          ancestors: Geoblacklight::Relation::Ancestors.new(@search_id, @repository).results,
          descendants: Geoblacklight::Relation::Descendants.new(@search_id, @repository).results,
          current_doc: id
        }
      end

      def empty?
        !(@relations[:ancestors]['numFound'] > 0 || @relations[:descendants]['numFound'] > 0)
      end
    end
  end
end

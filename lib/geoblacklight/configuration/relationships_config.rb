module Geoblacklight
  class Configuration
    # Hash-like configuration for the relationships displayed on a document's
    # show page. By default it carries all of the relationships defined in the
    # RELATIONSHIPS_SHOWN section of settings.yml, using lowercase keys.
    class RelationshipsConfig
      include Enumerable

      DEFAULT_RELATIONSHIPS = {
        member_of_ancestors: {
          field: "pcdm_memberOf_sm",
          icon: "parent-item",
          inverse: :member_of_descendants,
          label: "geoblacklight.relations.member_of_ancestors",
          query_type: "ancestors"
        },
        member_of_descendants: {
          field: "pcdm_memberOf_sm",
          icon: "child-item",
          inverse: :member_of_ancestors,
          label: "geoblacklight.relations.member_of_descendants",
          query_type: "descendants"
        },
        part_of_ancestors: {
          field: "dct_isPartOf_sm",
          icon: "parent-item",
          inverse: :part_of_descendants,
          label: "geoblacklight.relations.part_of_ancestors",
          query_type: "ancestors"
        },
        part_of_descendants: {
          field: "dct_isPartOf_sm",
          icon: "child-item",
          inverse: :part_of_ancestors,
          label: "geoblacklight.relations.part_of_descendants",
          query_type: "descendants"
        },
        relation_ancestors: {
          field: "dct_relation_sm",
          icon: nil,
          inverse: :relation_descendants,
          label: "geoblacklight.relations.relation_ancestors",
          query_type: "ancestors"
        },
        relation_descendants: {
          field: "dct_relation_sm",
          icon: nil,
          inverse: :relation_ancestors,
          label: "geoblacklight.relations.relation_descendants",
          query_type: "descendants"
        },
        replaces_ancestors: {
          field: "dct_replaces_sm",
          icon: nil,
          inverse: :replaces_descendants,
          label: "geoblacklight.relations.replaces_ancestors",
          query_type: "ancestors"
        },
        replaces_descendants: {
          field: "dct_replaces_sm",
          icon: nil,
          inverse: :replaces_ancestors,
          label: "geoblacklight.relations.replaces_descendants",
          query_type: "descendants"
        },
        source_ancestors: {
          field: "dct_source_sm",
          icon: "parent-item",
          inverse: :source_descendants,
          label: "geoblacklight.relations.source_ancestors",
          query_type: "ancestors"
        },
        source_descendants: {
          field: "dct_source_sm",
          icon: "child-item",
          inverse: :source_ancestors,
          label: "geoblacklight.relations.source_descendants",
          query_type: "descendants"
        },
        version_of_ancestors: {
          field: "dct_isVersionOf_sm",
          icon: "parent-item",
          inverse: :version_of_descendants,
          label: "geoblacklight.relations.version_of_ancestors",
          query_type: "ancestors"
        },
        version_of_descendants: {
          field: "dct_isVersionOf_sm",
          icon: "child-item",
          inverse: :version_of_ancestors,
          label: "geoblacklight.relations.version_of_descendants",
          query_type: "descendants"
        }
      }.freeze

      def initialize(relationships = DEFAULT_RELATIONSHIPS)
        @relationships = relationships.to_h.transform_values do |attrs|
          attrs.is_a?(RelationshipConfig) ? attrs : RelationshipConfig.new(attrs)
        end
      end

      def each(&block)
        @relationships.each(&block)
      end

      def each_key(&block)
        @relationships.each_key(&block)
      end

      def key?(key)
        @relationships.key?(key)
      end

      def [](key)
        @relationships[key]
      end

      def method_missing(name, *args, **kwargs, &block) # rubocop:disable Style/MissingRespondToMissing
        @relationships.key?(name) ? @relationships[name] : super
      end
    end
  end
end

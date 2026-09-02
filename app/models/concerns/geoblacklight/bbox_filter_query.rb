# frozen_string_literal: true

module Geoblacklight
  class BboxFilterQuery
    # Blacklight 9 instantiates a filter_query_builder with the blacklight_config and
    # calls #call(filter, solr_params). Blacklight 8 has no such branch: it always does
    # `filter.config.filter_query_builder.call(search_builder, filter, solr_params)`.
    #
    # @see https://github.com/projectblacklight/blacklight/blob/v8.12.3/lib/blacklight/solr/search_builder_behavior.rb#L132
    # @param search_builder [Blacklight::SearchBuilder]
    # @param filter [Geoblacklight::BboxFilterField]
    # @param solr_params [Hash]
    def self.call(search_builder, filter, solr_params)
      new(blacklight_config: search_builder.blacklight_config).call(filter, solr_params)
    end

    def call(filter, solr_params)
      @filter = filter
      [intersects_filter, relevancy_boost(solr_params)]
    end

    def initialize(blacklight_config:)
      @blacklight_config = blacklight_config
    end

    def intersects_filter
      "#{@filter.key}:\"Intersects(#{envelope_bounds})\""
    end

    def relevancy_boost(solr_params)
      boosted_params = solr_params.slice(:bq, :bf)

      boosted_params[:bq] ||= []
      boosted_params[:bq] << "#{@filter.key}:\"IsWithin(#{envelope_bounds})\"#{boost}"

      if field_config.overlap_boost
        boosted_params[:bf] ||= []
        boosted_params[:overlap] =
          "{!field uf=* defType=lucene f=#{field_config.overlap_field} score=overlapRatio}Intersects(#{envelope_bounds})"
        boosted_params[:bf] << "$overlap^#{field_config.overlap_boost}"
      end

      boosted_params
    end

    def envelope_bounds
      @filter.values.first.to_envelope
    end

    def boost
      "^#{field_config.within_boost || "10"}"
    end

    private

    def field_config
      @filter.config
    end
  end
end

# frozen_string_literal: true
module Geoblacklight
  module Relation
    class Ancestors
      def initialize(id, repository)
        @search_id = id
        @repository = repository
      end

      def create_search_params
        { fq: ["{!join from=#{Settings.FIELDS.SOURCE} to=layer_slug_s}layer_slug_s:#{@search_id}"],
          fl: [Settings.FIELDS.TITLE, 'layer_slug_s', Settings.FIELDS.GEOM_TYPE] }
      end

      def execute_query
        @repository.connection.send_and_receive(
          @repository.blacklight_config.solr_path,
          params: create_search_params
        )
      end

      def results
        response = execute_query
        response['response']
      end
    end
  end
end

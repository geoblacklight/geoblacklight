# frozen_string_literal: true

module Geoblacklight
  module Relation
    class Descendants
      def initialize(id, field, repository)
        @search_id = id
        @field = field
        @repository = repository
      end

      def create_search_params
        {fq: "#{@field}:#{@search_id}",
         fl: [Geoblacklight.configuration.fields.title, Geoblacklight.configuration.fields.id,
           Geoblacklight.configuration.fields.resource_type]}
      end

      def execute_query
        @repository.connection.send_and_receive(
          @repository.blacklight_config.solr_path,
          params: create_search_params
        )
      end

      def results
        response = execute_query
        response["response"]
      end
    end
  end
end

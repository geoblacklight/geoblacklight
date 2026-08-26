# frozen_string_literal: true

module Geoblacklight
  module Relations
    # Shared Solr query machinery for finding documents related to a given id via a
    # single field. Subclasses only need to supply the `fq` that expresses their
    # direction (ancestors vs. descendants); everything else - the fields fetched,
    # how many rows, and how the query is executed - is identical either way.
    class Query
      MAX_ROWS = 3

      def initialize(id, field, repository)
        @search_id = id
        @field = field
        @repository = repository
      end

      def execute_query
        @repository.connection.send_and_receive(
          @repository.blacklight_config.solr_path,
          params: create_search_params
        )
      end

      def results
        execute_query["response"]
      end

      private

      def shared_search_params
        {rows: MAX_ROWS,
         fl: [Geoblacklight.configuration.fields.title, Geoblacklight.configuration.fields.id,
           Geoblacklight.configuration.fields.resource_type, Geoblacklight.configuration.fields.description,
           Geoblacklight.configuration.fields.resource_class, Geoblacklight.configuration.fields.access_rights]}
      end
    end
  end
end

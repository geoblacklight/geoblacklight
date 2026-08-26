# frozen_string_literal: true

module Geoblacklight
  module Relations
    class Ancestors < Query
      def create_search_params
        {fq: ["{!join from=#{@field} to=#{Geoblacklight.configuration.fields.id}}#{Geoblacklight.configuration.fields.id}:#{@search_id}"]}
          .merge(shared_search_params)
      end
    end
  end
end

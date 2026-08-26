# frozen_string_literal: true

module Geoblacklight
  module Relations
    class Descendants < Query
      def create_search_params
        {fq: "#{@field}:#{@search_id}"}.merge(shared_search_params)
      end
    end
  end
end

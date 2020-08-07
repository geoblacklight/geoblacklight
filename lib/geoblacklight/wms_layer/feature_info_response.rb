# frozen_string_literal: true
module Geoblacklight
  class FeatureInfoResponse
    def initialize(response)
      @response = response
    end

    def check
      if error?
        @response
      else
        format
      end
    end

    def format
      page = Nokogiri::HTML(@response.body)
      table_values = { values: [] }
      page.css('th').each do |th|
        table_values[:values].push([th.text])
      end
      page.css('td').each_with_index do |td, index|
        table_values[:values][index].push(td.text) unless index >= table_values[:values].count
      end
      table_values
    end

    def error?
      @response[:error] ||
        @response.headers['content-type'].slice(0, 9) == 'text/xml'
    end
  end
end

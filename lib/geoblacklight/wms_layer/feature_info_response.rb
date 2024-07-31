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
      JSON.parse(@response.body)
    rescue
      page = Nokogiri::HTML(@response.body)
      properties = {}
      values = {}
      page.css("td").each_with_index do |td, index|
        values[index] = td.text
      end
      page.css("th").each_with_index do |th, index|
        properties[th.text] = values[index] unless index >= values.keys.count
      end
      {features: [{properties: properties, isHTML: true}]}
    end

    def error?
      @response[:error] ||
        @response.headers["content-type"].slice(0, 9) == "text/xml"
    end
  end
end

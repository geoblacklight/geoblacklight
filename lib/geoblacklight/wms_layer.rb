# frozen_string_literal: true

module Geoblacklight
  class WmsLayer
    def initialize(params)
      @params = params.to_h.merge(Geoblacklight.configuration.wms_params)
      @response = Geoblacklight::FeatureInfoResponse.new(request_response)
    end

    def url
      @params["URL"]
    end

    def search_params
      @params.except("URL")
    end

    def feature_info
      @response.check
    end

    def request_response
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = search_params
        request.options.timeout = Geoblacklight.configuration.timeout_wms
        request.options.open_timeout = Geoblacklight.configuration.timeout_wms
      end
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => error
      Geoblacklight.logger.error error.inspect
      {error: error.inspect}
    end
  end
end

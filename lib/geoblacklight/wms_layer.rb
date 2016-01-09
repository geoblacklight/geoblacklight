module Geoblacklight
  class WmsLayer

    def initialize(params)
      @params = params.merge(Settings.WMS_PARAMS)
      @response = Geoblacklight::FeatureInfoResponse.new(request_response)
    end

    def url
      @params['URL']
    end

    def search_params
      @params.except('URL')
    end

    def get_feature_info
      @response.check
    end

    def request_response
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = search_params
        request.options.timeout = Settings.TIMEOUT_WMS
        request.options.open_timeout = Settings.TIMEOUT_WMS
      end
    rescue Faraday::Error::ConnectionFailed => error
      Geoblacklight.logger.error error.inspect
      { error: error.inspect }
    rescue Faraday::Error::TimeoutError => error
      Geoblacklight.logger.error error.inspect
      { error: error.inspect }
    end
  end
end

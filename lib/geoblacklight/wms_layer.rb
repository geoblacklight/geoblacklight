require 'nokogiri'
require 'geoblacklight/wms_layer/feature_info_response'
class WmsLayer

  def initialize(params)
    @params = params.merge(Settings.WMS_PARAMS)
    @response = FeatureInfoResponse.new(request_response)
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
    begin
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = search_params
        request.options = {
          timeout: 2,
          open_timeout: 2
        }
      end
    rescue Faraday::Error::ConnectionFailed => error
      { error: error }
    rescue Faraday::Error::TimeoutError => error
      { error: error }
    end
  end
end

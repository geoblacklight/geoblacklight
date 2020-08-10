# frozen_string_literal: true
module Geoblacklight
  class HglDownload < Geoblacklight::Download
    def initialize(document, email, options = {})
      request_params = {
        'LayerName' => document[:layer_id_s].sub(/^cite:/, ''),
        'UserEmail' => email
      }
      super(document, {
        request_params: request_params,
        service_type: 'hgl'
      }.merge(options))
    end

    def get
      initiate_download
    end
  end
end

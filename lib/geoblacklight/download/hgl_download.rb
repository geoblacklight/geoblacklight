# frozen_string_literal: true

module Geoblacklight
  # @deprecated The Harvard Geospatial Library download integration is removed
  #   without replacement in GeoBlacklight 5.
  class HglDownload < Geoblacklight::Download
    def initialize(document, email, options = {})
      Geoblacklight.deprecation.warn(
        "Geoblacklight::HglDownload is deprecated without replacement and will be removed in GeoBlacklight 5"
      )
      request_params = {
        "LayerName" => document[Settings.FIELDS.WXS_IDENTIFIER].sub(/^cite:/, ""),
        "UserEmail" => email
      }
      super(document, {
        request_params: request_params,
        service_type: "hgl"
      }.merge(options))
    end

    def get
      initiate_download
    end
  end
end

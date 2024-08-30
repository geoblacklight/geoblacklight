# frozen_string_literal: true

module Geoblacklight
  class CsvDownload < Geoblacklight::Download
    CSV_DOWNLOAD_PARAMS = {service: "wfs",
                           version: "2.0.0",
                           request: "GetFeature",
                           srsName: "EPSG:4326",
                           outputformat: "csv"}.freeze

    def initialize(document, options = {})
      request_params = CSV_DOWNLOAD_PARAMS.merge(typeName: document.wxs_identifier)
      super(document, {
        type: "csv",
        extension: "csv",
        request_params: request_params,
        content_type: "text/csv",
        service_type: "wfs"
      }.merge(options))
    end
  end
end

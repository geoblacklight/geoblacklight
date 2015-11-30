module Geoblacklight
  class JpgDownload < Geoblacklight::Download

    def initialize(document, options = {})
      super(document, {
                        type: 'jpg',
                        extension: 'jpg',
                        request_params: {},
                        content_type: 'image/jpeg',
                        service_type: 'iiif'
                    }.merge(options))
    end
  end
end
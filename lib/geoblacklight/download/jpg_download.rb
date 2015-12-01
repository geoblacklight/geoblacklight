module Geoblacklight
  class JpgDownload < Geoblacklight::Download

    def url
      url = @document.download_types[:jpg][:iiif]
      url.slice! "info.json"
      url += "full/full/0/default.jpg"
    end

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
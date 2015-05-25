module Geoblacklight
  class ItemViewer
    def initialize(references)
      @references = references
    end

    def viewer_protocol
      return 'map' if viewer_preference.nil?
      viewer_preference.keys.first.to_s
    end

    def viewer_endpoint
      return '' if viewer_preference.nil?
      viewer_preference.values.first.to_s
    end

    def wms
      @references.wms
    end

    def iiif
      @references.iiif
    end

    def esrimapservice
      @references.esrimapservice
    end

    def viewer_preference
      [wms, iiif, esrimapservice].compact.map(&:to_hash).first
    end
  end
end

module Geoblacklight
  # References is a geoblacklight-schema dct:references parser
  class References
    def initialize(document)
      @document = document
    end

    def format
      @document[:dc_format_s]
    end

    def references
      parse_references.map { |ref| Reference.new(ref) }
    end

    def parse_references
      JSON.parse(@document[:dct_references_s])
    end

    def direct_download
      references.find { |reference| reference.type == :download }
    end

    def wms
      references.find { |reference| reference.type == :wms }
    end

    def wfs
      references.find { |reference| reference.type == :wfs }
    end

    def preferred_download
      return file_download unless direct_download.blank?
    end

    def file_download
      { file_download: direct_download.to_hash }
    end

    def downloads_by_format
      case format
      when 'Shapefile'
        { shapefile: wfs.to_hash, kmz: wms.to_hash }
      when 'GeoTIFF'
        { geotiff: wms.to_hash }
      end
    end

    def download_types
      downloads_by_format
    end
  end
end

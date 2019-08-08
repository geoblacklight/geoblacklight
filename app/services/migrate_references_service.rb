class MigrateReferencesService
  def initialize(document)
    @document = document
  end

  def migrate
    @document['downloads_sm'] = download_references unless download_references.empty?
    @document['metadata_sm'] = metadata_references unless metadata_references.empty?
    @document['webservices_sm'] = webservice_references unless webservice_references.empty?
    @document.delete('layer_id_s')
    @document.delete('dct_references_s')
    @document
  end

  private

    def download_references
      [
        download_original_ref,
        download_hgl_ref
      ].compact
    end

    def download_hgl_ref
      hgl_url = references['http://schema.org/DownloadAction']
      { 'type' => 'HGL', 'url' => hgl_url }.to_json if hgl_url
    end

    def download_original_ref
      format = @document['dc_format_s']
      download_url = references['http://schema.org/downloadUrl']
      return unless format && download_url
      label = "Original #{format}"
      { 'type' => format, 'url' => download_url, 'label' => label }.to_json
    end

    def metadata_constants
      {
        'http://www.opengis.net/cat/csw/csdgm' => 'FGDC',
        'http://www.w3.org/1999/xhtml' => 'HTML',
        'http://www.isotc211.org/schemas/2005/gmd/' => 'ISO19139',
        'http://www.loc.gov/mods/v3' => 'MODS',
        'http://lccn.loc.gov/sh85035852' => 'Data Dictionary',
        'http://schema.org/url' => 'External URL'
      }
    end

    def metadata_references
      references.collect do |k, v|
        type = metadata_constants[k]
        { 'type' => type, 'url' => v }.to_json if type
      end.compact
    end

    def references
      return {} unless @document['dct_references_s']
      @references ||= JSON.parse(@document['dct_references_s'])
    end

    def webservice_constants
      {
        'http://iiif.io/api/image' => 'IIIF',
        'http://iiif.io/api/presentation#manifest' => 'IIIF Manifest',
        'http://www.opengis.net/def/serviceType/ogc/wcs' => 'WCS',
        'http://www.opengis.net/def/serviceType/ogc/wfs' => 'WFS',
        'http://www.opengis.net/def/serviceType/ogc/wms' => 'WMS',
        'urn:x-esri:serviceType:ArcGIS#FeatureLayer' => 'Feature Layer',
        'urn:x-esri:serviceType:ArcGIS#TiledMapLayer' => 'Tiled Map Layer',
        'urn:x-esri:serviceType:ArcGIS#DynamicMapLayer' => 'Dynamic Map Layer',
        'urn:x-esri:serviceType:ArcGIS#ImageMapLayer' => 'Image Map Layer',
        'https://openindexmaps.org' => 'Index Map',
        'https://oembed.com' => 'oEmbed'
      }
    end

    def webservice_references
      references.collect do |k, v|
        type = webservice_constants[k]
        next unless type
        layer_id = @document['layer_id_s'] if ['WMS', 'WFS'].include? type
        {
          'type' => type,
          'url' => v,
          'layerId' => layer_id,
          'exportFormats' => export_formats(type)
        }.compact.to_json
      end.compact
    end

    def export_formats(type)
      case @document['dc_format_s']
      when 'Shapefile'
        shapefile_export_formats(type)
      when 'GeoTIFF'
        raster_export_formats(type)
      when 'ArcGRID'
        raster_export_formats(type)
      end
    end

    def shapefile_export_formats(type)
      if type == 'WMS'
        ['KMZ']
      elsif type == 'WFS'
        ['Shapefile', 'GeoJSON']
      end
    end

    def raster_export_formats(type)
      return unless type == 'WMS'
      ['GeoTIFF']
    end
end

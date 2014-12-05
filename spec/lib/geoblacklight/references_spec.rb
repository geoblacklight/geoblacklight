require 'spec_helper'

describe Geoblacklight::References do
  let(:typical_ogp_shapefile) {
    Geoblacklight::References.new(
      SolrDocument.new(
        dc_format_s: 'Shapefile',
        dct_references_s: {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  }
  let(:no_service_shapefile) {
    Geoblacklight::References.new(
      SolrDocument.new(
        dc_format_s: 'Shapefile',
        dct_references_s: {}.to_json
      )
    )
  }
  let(:typical_ogp_geotiff) {
    Geoblacklight::References.new(
      SolrDocument.new(
        dc_format_s: 'GeoTIFF',
        dct_references_s: {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  }
  let(:complex_shapefile) {
    Geoblacklight::References.new(
      SolrDocument.new(
        dc_format_s: 'Shapefile',
        dct_references_s: {
          'http://schema.org/downloadUrl' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip',
          'http://www.isotc211.org/schemas/2005/gmd/' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/iso19139.xml',
          'http://www.loc.gov/mods/v3' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/mods.xml',
          'http://schema.org/url' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/homepage',
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  }
  let(:direct_download_only) {
    Geoblacklight::References.new(
      dc_format_s: 'GeoTIFF',
      dct_references_s: {
        'http://schema.org/downloadUrl' => 'http://example.com/layer-id-geotiff.tiff'
      }.to_json
    )
  }
  describe 'format' do
    it 'should return format' do
      expect(complex_shapefile.format).to eq 'Shapefile'
      expect(direct_download_only.format).to eq 'GeoTIFF'
    end
  end
  describe 'refs' do
    it 'should be enumberable references' do
      complex_shapefile.refs.each do |reference|
        expect(reference).to be_an Geoblacklight::Reference
      end
    end
  end
  describe 'direct_download' do
    it 'should return the direct download link' do
      download = complex_shapefile.download
      expect(download).to be_an Geoblacklight::Reference
      expect(download.endpoint).to eq('http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip')
      expect(direct_download_only.download.endpoint).to eq 'http://example.com/layer-id-geotiff.tiff'
    end
    it 'should not return if download not available' do
      expect(typical_ogp_shapefile.download).to be_nil
    end
  end
  describe 'preferred_download' do
    it 'should return the direct download if available' do
      expect(complex_shapefile.preferred_download[:file_download][:download]).to eq 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip'
      expect(direct_download_only.preferred_download[:file_download][:download]).to eq 'http://example.com/layer-id-geotiff.tiff'
    end
    it 'should return nil if there is no direct download' do
      expect(typical_ogp_shapefile.preferred_download).to be_nil
    end
    it 'should return nil if there is no direct download' do
      expect(typical_ogp_geotiff.preferred_download).to be_nil
    end
  end
  describe 'download_types' do
    it 'should return available downloads by format' do
      types = complex_shapefile.download_types
      expect(types.first[1]).to eq wfs: 'http://hgl.harvard.edu:8080/geoserver/wfs'
      expect(types.count).to eq 3
      expect(direct_download_only.download_types).to be_nil
    end
    it 'should only return available downloads if no direct is present' do
      types = typical_ogp_shapefile.download_types
      expect(types.first[1]).to eq wfs: "http://hgl.harvard.edu:8080/geoserver/wfs"
      expect(types.count).to eq 3
    end
  end
  describe 'downloads_by_format' do
    it 'returns shapefile' do
      expect(typical_ogp_shapefile.downloads_by_format.count).to eq 3
    end
    it 'returns geotiff' do
      expect(typical_ogp_geotiff.downloads_by_format.count).to eq 1
      expect(typical_ogp_geotiff.downloads_by_format[:geotiff][:wms]).to eq 'http://hgl.harvard.edu:8080/geoserver/wms'
    end
    it 'does not return shapefile if wms and wfs are not present' do
      expect(no_service_shapefile.downloads_by_format).to be_nil
    end
    it 'does not return GeoTIFF if wms is not present' do
      expect(direct_download_only.downloads_by_format).to be_nil
    end
  end
end

require 'spec_helper'

describe Geoblacklight::References do
  let(:references_field) { Settings.FIELDS.REFERENCES }
  let(:file_format_field) { Settings.FIELDS.FILE_FORMAT }
  let(:typical_ogp_shapefile) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'Shapefile',
        references_field => {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  end
  let(:no_service_shapefile) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'Shapefile',
        references_field => {}.to_json
      )
    )
  end
  let(:typical_ogp_geotiff) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'GeoTIFF',
        references_field => {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  end
  let(:typical_arcgrid) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'ArcGRID',
        references_field => {
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  end
  let(:complex_shapefile) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'Shapefile',
        references_field => {
          'http://schema.org/downloadUrl' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip',
          'http://www.isotc211.org/schemas/2005/gmd/' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/iso19139.xml',
          'http://www.loc.gov/mods/v3' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/mods.xml',
          'http://schema.org/url' => 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/homepage',
          'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://hgl.harvard.edu:8080/geoserver/wms',
          'http://www.opengis.net/def/serviceType/ogc/wfs' => 'http://hgl.harvard.edu:8080/geoserver/wfs'
        }.to_json
      )
    )
  end
  let(:direct_download_only) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'GeoTIFF',
        references_field => {
          'http://schema.org/downloadUrl' => 'http://example.com/layer-id-geotiff.tiff'
        }.to_json
      )
    )
  end
  let(:simple_iiif_image) do
    described_class.new(
      SolrDocument.new(
        file_format_field => 'Raster',
        references_field => {
          'http://schema.org/url' => 'http://arks.princeton.edu/ark:/88435/02870w62c',
          'http://iiif.io/api/image' => 'http://libimages.princeton.edu/loris2/pudl0076%2Fmap_pownall%2F00000001.jp2/info.json'
        }.to_json
      )
    )
  end
  let(:custom_fields) do
    described_class.new(
      SolrDocument.new, :new_ref_field
    )
  end
  describe '#initialize' do
    it 'parses configured references field to @refs' do
      expect(typical_ogp_shapefile.instance_variable_get(:@refs)).to be_an Array
    end
    it 'empty references return an empty array' do
      empty_refs = no_service_shapefile.instance_variable_get(:@refs)
      expect(empty_refs).to be_an Array
      expect(empty_refs).to eq []
    end
    it 'sets @references_field' do
      expect(typical_ogp_shapefile.reference_field).to eq references_field
      expect(custom_fields.reference_field).to eq :new_ref_field
    end
  end
  describe 'format' do
    it 'returns format' do
      expect(complex_shapefile.format).to eq 'Shapefile'
      expect(direct_download_only.format).to eq 'GeoTIFF'
    end
  end
  describe 'refs' do
    it 'is enumberable references' do
      complex_shapefile.refs.each do |reference|
        expect(reference).to be_an Geoblacklight::Reference
      end
    end
  end
  describe 'direct_download' do
    it 'returns the direct download link' do
      download = complex_shapefile.download
      expect(download).to be_an Geoblacklight::Reference
      expect(download.endpoint).to eq('http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip')
      expect(direct_download_only.download.endpoint).to eq 'http://example.com/layer-id-geotiff.tiff'
    end
    it 'does not return if download not available' do
      expect(typical_ogp_shapefile.download).to be_nil
    end
  end
  describe 'preferred_download' do
    it 'returns the direct download if available' do
      expect(complex_shapefile.preferred_download[:file_download][:download]).to eq 'http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip'
      expect(direct_download_only.preferred_download[:file_download][:download]).to eq 'http://example.com/layer-id-geotiff.tiff'
    end
    it 'returns nil if there is no direct download' do
      expect(typical_ogp_shapefile.preferred_download).to be_nil
    end
    it 'returns nil if there is no direct download' do
      expect(typical_ogp_geotiff.preferred_download).to be_nil
    end
  end
  describe 'download_types' do
    it 'returns available downloads by format' do
      types = complex_shapefile.download_types
      expect(types.first[1]).to eq wfs: 'http://hgl.harvard.edu:8080/geoserver/wfs'
      expect(types.count).to eq 3
      expect(direct_download_only.download_types).to be_nil
    end
    it 'onlies return available downloads if no direct is present' do
      types = typical_ogp_shapefile.download_types
      expect(types.first[1]).to eq wfs: 'http://hgl.harvard.edu:8080/geoserver/wfs'
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
    it 'returns arcgrid as geotiff' do
      expect(typical_arcgrid.downloads_by_format.count).to eq 1
      expect(typical_arcgrid.downloads_by_format[:geotiff][:wms]).to eq 'http://hgl.harvard.edu:8080/geoserver/wms'
    end
    it 'does not return shapefile if wms and wfs are not present' do
      expect(no_service_shapefile.downloads_by_format).to be_nil
    end
    it 'does not return GeoTIFF if wms is not present' do
      expect(direct_download_only.downloads_by_format).to be_nil
    end
  end
end

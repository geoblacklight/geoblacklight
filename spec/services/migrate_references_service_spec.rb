require 'spec_helper'

describe MigrateReferencesService do
  describe '#migrate' do
    subject(:output_document) { described_class.new(input_document).migrate }
    let(:input_document) { JSON.parse(file) }
    let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'public_direct_download.json')) }

    it 'migrates download references' do
      downloads = output_document['downloads_sm'].map { |d| JSON.parse(d) }
      expect(downloads[0]['type']).to eq 'Shapefile'
      expect(downloads[0]['url']).to eq 'http://stacks.stanford.edu/file/druid:cz128vq0535/data.zip'
      expect(downloads[0]['label']).to eq 'Original Shapefile'
      expect(output_document['layer_id_s']).to be_nil
      expect(output_document['dct_references_s']).to be_nil
    end

    it 'migrates metadata references' do
      metadata = output_document['metadata_sm'].map { |m| JSON.parse(m) }
      expect(metadata[0]['type']).to eq 'URL'
      expect(metadata[0]['url']).to eq 'http://purl.stanford.edu/cz128vq0535'
      expect(metadata[1]['type']).to eq 'MODS'
      expect(metadata[1]['url']).to eq 'http://purl.stanford.edu/cz128vq0535.mods'
      expect(metadata[2]['type']).to eq 'ISO19139'
      expect(metadata[2]['url']).to eq 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.stanford.purl/master/cz/128/vq/0535/iso19139.xml'
    end

    it 'migrates webservice references' do
      webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
      expect(webservices[0]['type']).to eq 'WFS'
      expect(webservices[0]['url']).to eq 'https://geowebservices.stanford.edu/geoserver/wfs'
      expect(webservices[0]['layerId']).to eq 'druid:cz128vq0535'
      expect(webservices[0]['exportFormats']).to eq ['Shapefile', 'GeoJSON']
      expect(webservices[1]['type']).to eq 'WMS'
      expect(webservices[1]['url']).to eq 'https://geowebservices.stanford.edu/geoserver/wms'
      expect(webservices[1]['layerId']).to eq 'druid:cz128vq0535'
      expect(webservices[1]['exportFormats']).to eq ['KMZ']
    end

    context 'with a raster document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'actual-raster1.json')) }

      it 'migrates wms service ref with export format' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[1]['type']).to eq 'WMS'
        expect(webservices[1]['url']).to eq 'https://geowebservices-restricted.stanford.edu/geoserver/wms'
        expect(webservices[1]['layerId']).to eq 'druid:dp018hs9766'
        expect(webservices[1]['exportFormats']).to eq ['GeoTIFF']
      end
    end

    context 'with an arcgrid document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'arcgrid.json')) }

      it 'migrates wms service ref with export format' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[1]['type']).to eq 'WMS'
        expect(webservices[1]['url']).to eq 'https://geowebservices.stanford.edu/geoserver/wms'
        expect(webservices[1]['layerId']).to eq 'druid:vh469wk7989'
        expect(webservices[1]['exportFormats']).to eq ['GeoTIFF']
      end
    end

    context 'with a Harvard raster document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'harvard_raster.json')) }

      it 'migrates hgl download ref and WCS service ref' do
        downloads = output_document['downloads_sm'].map { |d| JSON.parse(d) }
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(downloads[0]['type']).to eq 'HGL'
        expect(downloads[0]['url']).to eq 'http://pelham.lib.harvard.edu:8080/HGL/HGLOpenDelivery'
        expect(webservices[0]['type']).to eq 'WCS'
        expect(webservices[0]['url']).to eq 'http://pelham.lib.harvard.edu:8090/geoserver/wcs'
        expect(webservices[1]['layerId']).to eq 'cite:G7064_S2_1834_K3'
      end
    end

    context 'with a IIIF scanned map document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'princeton-parent.json')) }

      it 'migrates iiif service ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[0]['type']).to eq 'IIIF'
        expect(webservices[0]['url']).to eq 'https://libimages1.princeton.edu/loris/figgy_prod/5a%2F20%2F58%2F5a20585db50d44959fe5ae44821fd174%2Fintermediate_file.jp2/info.json'
        expect(webservices[1]['type']).to eq 'IIIF Manifest'
        expect(webservices[1]['url']).to eq 'https://figgy.princeton.edu/concern/scanned_maps/9a193476-5f2e-4f82-95a5-6db472e39b7b/manifest'
      end
    end

    context 'with an ESRI feature layer document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'esri-feature-layer.json')) }

      it 'migrates feature layer service ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[0]['type']).to eq 'Feature Layer'
        expect(webservices[0]['url']).to eq 'https://geodata.md.gov/imap/rest/services/Transportation/MD_Transit/FeatureServer/18'
      end
    end

    context 'with an ESRI tiled map layer document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'esri-tiled_map_layer.json')) }

      it 'migrates tiled map layer service ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[0]['type']).to eq 'Tiled Map Layer'
        expect(webservices[0]['url']).to eq 'http://services.arcgisonline.com/arcgis/rest/services/Specialty/Soil_Survey_Map/MapServer'
      end
    end

    context 'with an ESRI feature dynamic map layer document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'esri-dynamic-layer-single-layer.json')) }

      it 'migrates dynamic map layer service ref and FGDC metadata ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        metadata = output_document['metadata_sm'].map { |m| JSON.parse(m) }
        expect(webservices[0]['type']).to eq 'Dynamic Map Layer'
        expect(webservices[0]['url']).to eq 'https://maps.indiana.edu/arcgis/rest/services/Geology/Industrial_Minerals_Quarries_Abandoned/MapServer/0'
        expect(metadata[1]['type']).to eq 'FGDC'
        expect(metadata[1]['url']).to eq 'http://maps.indiana.edu/metadata/Geology/Industrial_Minerals_Quarries_Abandoned.xml'
      end
    end

    context 'with an ESRI image map layer document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'esri-image-map-layer.json')) }

      it 'migrates image map layer ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[0]['type']).to eq 'Image Map Layer'
        expect(webservices[0]['url']).to eq 'https://mapsweb.lib.purdue.edu/arcgis/rest/services/Purdue/wabashtopo/ImageServer'
      end
    end

    context 'with an index map document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'index_map_point.json')) }

      it 'migrates an index map service ref and GeoJSON original file ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        downloads = output_document['downloads_sm'].map { |d| JSON.parse(d) }
        expect(webservices[0]['type']).to eq 'Index Map'
        expect(webservices[0]['url']).to eq 'https://raw.githubusercontent.com/OpenIndexMaps/edu.cornell/master/ny-aerial-photos-1960s.geojson'
        expect(downloads[0]['type']).to eq 'GeoJSON'
        expect(downloads[0]['url']).to eq 'https://raw.githubusercontent.com/OpenIndexMaps/edu.cornell/master/ny-aerial-photos-1960s.geojson'
        expect(downloads[0]['label']).to eq 'Original GeoJSON'
      end
    end

    context 'with an oEmbed document' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'oembed.json')) }

      it 'migrates oembed service ref' do
        webservices = output_document['webservices_sm'].map { |s| JSON.parse(s) }
        expect(webservices[0]['type']).to eq 'oEmbed'
        expect(webservices[0]['url']).to eq 'https://purl.stanford.edu/embed.json?&hide_title=true&url=https://purl.stanford.edu/dc482zx1528'
      end
    end

    context 'with a document containing a data dictionary' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'baruch_documentation_download.json')) }

      it 'migrates data dictionary ref' do
        metadata = output_document['metadata_sm'].map { |d| JSON.parse(d) }
        expect(metadata[2]['type']).to eq 'Data Dictionary'
        expect(metadata[2]['url']).to eq 'https://archive.nyu.edu/retrieve/74755/nyu_2451_34502_doc.zip'
      end
    end

    context 'with a document containing html metadata' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'cornell_html_metadata.json')) }

      it 'migrates data dictionary ref' do
        metadata = output_document['metadata_sm'].map { |d| JSON.parse(d) }
        expect(metadata[1]['type']).to eq 'HTML'
        expect(metadata[1]['url']).to eq 'https://s3.amazonaws.com/cugir-data/00/77/41/fgdc.html'
      end
    end

    context 'with a document that has no dct references' do
      let(:file) { File.read(File.join('spec', 'fixtures', 'dct_ref_documents', 'no_spatial.json')) }

      it 'returns an identical document' do
        expect(output_document).to eq input_document
      end
    end
  end
end

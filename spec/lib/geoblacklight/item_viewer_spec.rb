require 'spec_helper'

describe Geoblacklight::ItemViewer do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) { {} }
  let(:references) { document.references }
  let(:item_viewer) { Geoblacklight::ItemViewer.new(references) }
  describe 'viewer_preference' do
    describe 'for no references' do
      it 'returns nil' do
        expect(item_viewer.viewer_preference).to be_nil
      end
    end
    describe 'for wms reference' do
      let(:document_attributes) {
        {
          dct_references_s: {
            'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms',
            'http://iiif.io/api/image' => 'http://www.example.com/iiif'
          }.to_json
        }
      }
      it 'wms if wms is present' do
        expect(item_viewer.viewer_preference).to eq wms: 'http://www.example.com/wms'
      end
    end
    describe 'for iiif only reference' do
      let(:document_attributes) {
        {
          dct_references_s: {
            'http://iiif.io/api/image' => 'http://www.example.com/iiif'
          }.to_json
        }
      }
      it 'returns iiif' do
        expect(item_viewer.viewer_preference).to eq iiif: 'http://www.example.com/iiif'
      end
    end
    describe 'for tiled map layer reference' do
      let(:document_attributes) {
        {
          dct_references_s: {
            'http://www.arcgis.com/rdf#TiledMapLayer' => 'http://www.example.com/MapServer'
          }.to_json
        }
      }
      it 'returns mapservice' do
        expect(item_viewer.viewer_preference).to eq tiled_map_layer: 'http://www.example.com/MapServer'
      end
    end
  end
end

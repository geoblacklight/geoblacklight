require 'spec_helper'

describe Geoblacklight::DocumentPresenter do
  let(:request_context) { double(add_facet_params: '') }
  let(:config) { Blacklight::Configuration.new }
  subject { presenter }
  let(:presenter) do
    Geoblacklight::DocumentPresenter.new(document, request_context, config)
  end

  let(:document) do
    SolrDocument.new(id: 1, layer_id_s: 'druid:abc123')
  end

  describe '#wxs_identifier' do
    describe 'without wxs identifier in configuration' do
    end
    it 'returns empty string' do
      expect(subject.wxs_identifier).to eq ''
    end
    describe 'without wxs identifier in configuration' do
      let(:config) do
        Blacklight::Configuration.new.configure do |config|
          config.wxs_identifier_field = 'layer_id_s'
        end
      end
      it 'returns configured field' do
        expect(subject.wxs_identifier).to eq 'druid:abc123'
      end
    end
  end
end

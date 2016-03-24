require 'spec_helper'

describe Geoblacklight::DocumentPresenter do
  let(:request_context) { double(add_facet_params: '') }
  let(:wxs_identifier_field) { Blacklight::Configuration.new }
  let(:solr_fields) { Settings.FIELDS }
  subject { presenter }
  let(:presenter) do
    described_class.new(document, request_context, config)
  end

  let(:document) do
    SolrDocument.new(id: 1, layer_id_s: 'druid:abc123')
  end

  describe '#wxs_identifier' do
    context 'document without wxs identifier field present' do
      before { solr_fields.WXS_IDENTIFIER = 'non_present_field' }
      it 'returns empty string' do
        expect(subject.wxs_identifier).to eq ''
      end
    end
    context 'without wxs identifier in configuration' do
      before { solr_fields.WXS_IDENTIFIER = 'layer_id_s' }
      it 'returns configured field' do
        expect(subject.wxs_identifier).to eq 'druid:abc123'
      end
    end
  end
end

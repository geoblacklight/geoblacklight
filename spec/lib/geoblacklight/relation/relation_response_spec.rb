# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::Relation::RelationResponse do
  let(:repository) { Blacklight::Solr::Repository.new(CatalogController.blacklight_config) }
  let(:relation_resp) { described_class.new('nyu_2451_34502', repository) }
  let(:empty_relation_resp) { described_class.new('harvard-g7064-s2-1834-k3', repository) }
  describe '#initialize' do
    it 'creates a RelationResponse' do
      expect(relation_resp).to be_an described_class
    end
  end

  describe '#method_missing' do
    it 'returns a hash of ancestor documents' do
      expect(relation_resp.SOURCE_ANCESTORS).to include('numFound')
      expect(relation_resp.SOURCE_ANCESTORS).to include('docs')
    end

    it 'returns a hash of descendant documents' do
      expect(relation_resp.SOURCE_DESCENDANTS).to include('numFound')
      expect(relation_resp.SOURCE_DESCENDANTS).to include('docs')
    end

    it 'raises no method error' do
      expect { relation_resp.FAIL }.to raise_error NoMethodError
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for configured relationships' do
      Settings.RELATIONSHIPS_SHOWN.each_key do |key|
        expect(relation_resp).to respond_to(key)
      end
    end

    it 'returns false for non-configured options' do
      expect(relation_resp).not_to respond_to('fail')
    end
  end

  describe '#query_type' do
    it 'fails for a bad query type request' do
      Settings.add_source!({
                             RELATIONSHIPS_SHOWN: {
                               BAD: {
                                 field: 'dct_source_sm',
                                 query_type: 'bad_query_type',
                                 icon: 'pagelines-brands',
                                 label: 'geoblacklight.relations.ancestor'
                               }
                             }
                           })
      Settings.reload!

      expect { relation_resp.BAD }.to raise_error(ArgumentError)
    end
  end
end

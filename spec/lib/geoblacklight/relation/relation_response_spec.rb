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

  describe '#ancestors' do
    it 'returns a hash of ancestor documents' do
      expect(relation_resp.ancestors).to include('numFound')
      expect(relation_resp.ancestors).to include('docs')
    end
  end

  describe '#descendants' do
    it 'returns a hash of descendant documents' do
      expect(relation_resp.ancestors).to include('numFound')
      expect(relation_resp.ancestors).to include('docs')
    end
  end

  describe '#empty?' do
    it 'returns false if document has ancestors or descendants' do
      expect(relation_resp.empty?).to be false
    end
    it 'returns true if document has neither ancestors nor descendants' do
      expect(empty_relation_resp.empty?).to be true
    end
  end
end

require 'spec_helper'

describe Geoblacklight::Relation::Descendants do
  let(:repository) { Blacklight::Solr::Repository.new(CatalogController.blacklight_config) }
  let(:descendants) { described_class.new('nyu_2451_34636', repository) }
  let(:empty_descendants) { described_class.new('harvard-g7064-s2-1834-k3', repository) }

  describe '#create_search_params' do
    it 'assembles the correct search params for finding descendant documents' do
      expect(descendants.create_search_params).to eq(fq: "#{Settings.FIELDS.SOURCE}:nyu_2451_34636", fl: [Settings.FIELDS.TITLE.to_s, 'layer_slug_s'])
    end
  end

  describe '#execute_query' do
    it 'executes the query for finding descendants, return response' do
      expect(descendants.execute_query).to include('responseHeader')
    end
  end

  describe '#results' do
    it 'produces a hash of results from the query' do
      expect(descendants.results).to include('numFound')
      expect(descendants.results).to include('docs')
    end
    it 'has non-zero numfound for a document with descendants' do
      expect(descendants.results['numFound']).to be > 0
    end
    it 'has zero numfound for a document without descendants' do
      expect(empty_descendants.results['numFound']).to eq(0)
    end
  end
end

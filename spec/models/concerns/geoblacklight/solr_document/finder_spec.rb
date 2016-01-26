require 'spec_helper'

describe Geoblacklight::SolrDocument::Finder do
  let(:subject) { Geoblacklight::SolrDocument }
  describe '#find' do
    it 'calls index and returns first document' do
      documents = %w(first second)
      response = double('response')
      index = double('index')
      expect(response).to receive(:documents).and_return(documents)
      expect(index).to receive(:find).with('search param').and_return(response)
      expect(subject).to receive(:index).and_return(index)
      expect(subject.find('search param')).to eq 'first'
    end
  end
  describe '#index' do
    it 'creates and returns a Blacklight::Solr::Repository' do
      expect(subject.index).to be_an Blacklight::Solr::Repository
    end
  end
end

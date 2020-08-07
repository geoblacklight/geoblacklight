# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::SolrDocument::Finder do
  let(:document_klass) { MyDocument }

  before do
    class MyDocument
      extend Blacklight::Solr::Document
      include Geoblacklight::SolrDocument::Finder
    end
  end

  describe '#find' do
    let(:documents) { ['first', 'second'] }
    let(:response) { instance_double(Blacklight::Solr::Response) }

    before do
      allow(response).to receive(:documents).and_return(documents)
      allow_any_instance_of(Blacklight::Solr::Repository).to receive(:find).with('search param').and_return(response)
    end

    it 'calls index and returns first document' do
      expect(document_klass.find('search param')).to eq 'first'
    end
  end

  describe '#index' do
    it 'creates and returns a Blacklight::Solr::Repository' do
      expect(document_klass.index).to be_a Blacklight::Solr::Repository
    end
  end

  describe '.blacklight_solr' do
    let(:document) { document_klass.new }

    it 'accesses the connection to the Solr index' do
      expect(document.blacklight_solr).to be_a RSolr::Client
    end
  end
end

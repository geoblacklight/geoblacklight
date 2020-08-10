# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::Metadata::Base do
  subject(:metadata) { described_class.new(reference) }

  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response) }
  let(:reference) do
    Geoblacklight::Reference.new(['http://www.loc.gov/mods/v3', 'http://purl.stanford.edu/cg357zz0321.mods'])
  end

  before do
    allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)
  end

  describe '#document' do
    context 'with valid XML data at an endpoint URL' do
      before do
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('<test>data</test>')
        allow(connection).to receive(:get).and_return(response)
      end

      it 'returns an XML Document containing the payload from an endpoint url' do
        expect(metadata.document).to be_a Nokogiri::XML::Document
      end
    end

    context 'when attempts to connect to an endpoint URL fail' do
      subject { metadata.document }

      before do
        allow(connection).to receive(:get).and_raise(Faraday::ConnectionFailed, 'test connection failures')
      end

      it 'returns nil when a connection error' do
        expect(subject).to be_a Nokogiri::XML::Document
        expect(subject.children.empty?).to be true
      end
    end
  end

  context 'when attempts to connect to an endpoint URL raise an OpenSSL error' do
    subject { metadata.document }

    before do
      expect(Geoblacklight.logger).to receive(:error).with(/dh key too small/)
      allow(connection).to receive(:get).and_raise(OpenSSL::SSL::SSLError, 'dh key too small')
    end

    it 'returns nil when a connection error' do
      expect(subject).to be_a Nokogiri::XML::Document
      expect(subject.children.empty?).to be true
    end
  end

  describe '#blank?' do
    before do
      allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)
    end

    context 'with valid XML data at an endpoint URL' do
      before do
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('<test>data</test>')
        allow(connection).to receive(:get).and_return(response)
      end

      it 'returns false' do
        expect(metadata.blank?).to be false
      end
    end

    context 'when attempts to connect to an endpoint URL fail' do
      before do
        allow(connection).to receive(:get).and_raise(Faraday::ConnectionFailed, 'test connection failures')
      end

      it 'returns true' do
        expect(metadata.blank?).to be true
      end
    end
  end

  describe '#endpoint' do
    before do
      allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('<test>data</test>')
      allow(connection).to receive(:get).and_return(response)
    end

    it 'returns the URI' do
      expect(metadata.endpoint).to eq 'http://purl.stanford.edu/cg357zz0321.mods'
    end
  end

  describe '#to_html' do
    let(:ns) { 'http://www.opengis.net/cat/csw/csdgm' }
    let(:url) { 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.tufts/master/165/242/110/132/fgdc.xml' }
    let(:reference) do
      Geoblacklight::Reference.new([ns, url])
    end
    let(:connection) { instance_double(Faraday::Connection) }
    let(:response) { instance_double(Faraday::Response) }
    let(:geocombine_metadata) { instance_double(GeoCombine::Iso19139) }
    let(:html) { '<!DOCTYPE html><html></html>' }
    let(:status) { 200 }

    before do
      allow(GeoCombine::Metadata).to receive(:new).and_return(geocombine_metadata)

      allow(connection).to receive(:use)
      allow(connection).to receive(:adapter)
      allow(Faraday).to receive(:new).and_yield(connection).and_return(connection)

      allow(response).to receive(:status).and_return(status)
      allow(response).to receive(:body).and_return('<?xml version="1.0" encoding="utf-8" ?><!DOCTYPE metadata SYSTEM "http://www.fgdc.gov/metadata/fgdc-std-001-1998.dtd"><metadata></metadata>')
    end

    it 'retrieves the metadata and transforms it into  the HTML' do
      allow(geocombine_metadata).to receive(:to_html).and_return(html)
      allow(connection).to receive(:get).and_return(response)

      expect(metadata.to_html).to eq html
    end

    context 'when the metadata resource cannot be found' do
      let(:status) { 404 }

      before do
        allow(Geoblacklight.logger).to receive(:error).with("Could not reach #{url}")
      end

      it 'logs an error and returns an empty String' do
        allow(geocombine_metadata).to receive(:to_html).and_return('')
        allow(connection).to receive(:get).and_return(response)

        expect(Geoblacklight.logger).to receive(:error)
        expect(metadata.to_html).to be_empty
      end
    end

    context 'when requesting the metadata resource times out' do
      before do
        allow(geocombine_metadata).to receive(:to_html).and_return('')
        allow(connection).to receive(:get).and_raise(Faraday::TimeoutError)
        allow(Geoblacklight.logger).to receive(:error).with('#<Faraday::TimeoutError #<Faraday::TimeoutError: timeout>>')
      end

      it 'logs an error and returns an empty String' do
        expect(Geoblacklight.logger).to receive(:error)
        expect(metadata.to_html).to be_empty
      end
    end
  end
end

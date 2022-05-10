# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::MetadataTransformer::Iso19139 do
  subject do
    described_class.new(metadata)
  end
  let(:iso_html) { File.read(Rails.root.join('spec', 'fixtures', 'metadata', 'iso.html')) }
  let(:metadata) { instance_double(Geoblacklight::Metadata::Iso19139) }

  describe '#transform' do
    before do
      expect(metadata).to receive(:blank?).and_return(false)
      expect(metadata).to receive(:to_html).and_return(iso_html)
    end

    it 'transforms ISO19139 Documents in the XML into the HTML' do
      transformed = Nokogiri::XML.fragment(subject.transform)
      expect(transformed.at_xpath('.//h1').text.strip).to eq('Abandoned Mine Land Inventory Polygons: Pennsylvania, 2016')
      expect(transformed.at_xpath('(.//div)[1]/dl/dd/dl/dd/dl/dt').text).to eq('Title')
      expect(transformed.at_xpath('(.//div)[1]/dl/dd/dl/dd/dl/dd').text.strip).to eq('Abandoned Mine Land Inventory Polygons: Pennsylvania, 2016')
    end
  end
end

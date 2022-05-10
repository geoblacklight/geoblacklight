# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::MetadataTransformer::Fgdc do
  subject do
    described_class.new(metadata)
  end
  let(:fgdc_html) { File.read(Rails.root.join('spec', 'fixtures', 'metadata', 'fgdc.html')) }
  let(:metadata) { instance_double(Geoblacklight::Metadata::Fgdc) }

  describe '#transform' do
    before do
      allow(metadata).to receive(:blank?).and_return(false)
      allow(metadata).to receive(:to_html).and_return(fgdc_html)
    end

    it 'transforms FGDC Documents in the XML into the HTML' do
      transformed = Nokogiri::XML.fragment(subject.transform)
      expect(transformed.at_xpath('.//h1').text.strip).to eq('Custom Link Sample')
      expect(transformed.at_xpath('.//div/dl/dd/dl/dd/dl/dt').text).to eq('Originator')
      expect(transformed.at_xpath('.//div/dl/dd/dl/dd/dl/dd').text.strip).to eq('Esri')
    end
  end
end

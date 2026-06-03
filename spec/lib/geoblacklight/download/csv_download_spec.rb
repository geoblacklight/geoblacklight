# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::CsvDownload do
  let(:document) { SolrDocument.new(Geoblacklight.configuration.fields.id => "test", :solr_wfs_url => "http://www.example.com/wfs", Geoblacklight.configuration.fields.wxs_identifier => "stanford-test", Geoblacklight.configuration.fields.geometry => "ENVELOPE(-180, 180, 90, -90)") }
  let(:download) { described_class.new(document) }
  describe "#initialize" do
    it "initializes as a CsvDownload object with specific options" do
      expect(download).to be_an described_class
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq "text/csv"
      expect(options[:request_params][:typeName]).to eq "stanford-test"
    end
    it "merges custom options" do
      download = described_class.new(document, timeout: 33)
      options = download.instance_variable_get(:@options)
      expect(options[:timeout]).to eq 33
    end
  end
end

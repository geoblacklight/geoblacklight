# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::GeojsonDownload do
  let(:document) { SolrDocument.new(Settings.FIELDS.ID => "test", :solr_wfs_url => "http://www.example.com/wfs", Settings.FIELDS.WXS_IDENTIFIER => "stanford-test", Settings.FIELDS.GEOMETRY => "ENVELOPE(-180, 180, 90, -90)") }
  let(:download) { described_class.new(document) }
  describe "#initialize" do
    it "initializes as a GeojsonDownload object with specific options" do
      expect(download).to be_an described_class
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq "application/json"
      expect(options[:request_params][:typeName]).to eq "stanford-test"
    end
    it "merges custom options" do
      download = described_class.new(document, timeout: 33)
      options = download.instance_variable_get(:@options)
      expect(options[:timeout]).to eq 33
    end
  end
end

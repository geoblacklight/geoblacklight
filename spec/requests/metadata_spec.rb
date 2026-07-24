# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Metadata", type: :request do
  subject(:response_page) { Capybara.string(response.body) }

  let(:mods) { File.read(Rails.root.join("..", "spec", "fixtures", "mods", "stanford-bc576pk4911.mods")) }
  let(:fgdc) { File.read(Rails.root.join("..", "spec", "fixtures", "fgdc", "SANB_a2725322-fgdc.xml")) }
  let(:iso19139) { File.read(Rails.root.join("..", "spec", "fixtures", "iso19139", "SANB_a2725322-iso19139.xml")) }

  before do
    allow(Faraday).to receive(:new).and_call_original
    stub_metadata_request("http://purl.stanford.edu/bc576pk4911.mods", mods)
    stub_metadata_request("https://stacks.stanford.edu/file/druid:bc576pk4911/SANB_a2725322-fgdc.xml", fgdc)
    stub_metadata_request("https://stacks.stanford.edu/file/druid:bc576pk4911/SANB_a2725322-iso19139.xml", iso19139)
    get metadata_solr_document_path("stanford-bc576pk4911")
  end

  it "renders syntax-highlighted MODS" do
    is_expected.to have_css(".pill-metadata", text: "MODS")
    is_expected.to have_css(".CodeRay")
  end

  it "renders FGDC metadata as HTML" do
    is_expected.to have_css(".pill-metadata", text: "FGDC")
    is_expected.to have_css("dd", text: "FGDC Content Standard for Digital Geospatial Metadata")
  end

  it "renders ISO19139 metadata as HTML" do
    is_expected.to have_css(".pill-metadata", text: "ISO 19139")
    is_expected.to have_css("dd", text: "ISO 19139 Geographic Information - Metadata - Implementation Specification")
  end

  def stub_metadata_request(url, body)
    response = instance_double(Faraday::Response, body: body, status: 200)
    connection = instance_double(Faraday::Connection, get: response)
    allow(Faraday).to receive(:new).with(url: url).and_return(connection)
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Metadata", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  let(:iso19139) { File.read(Rails.root.join("..", "spec", "fixtures", "iso19139", "stanford-cg357zz0321.xml")) }
  let(:fgdc) { File.read(Rails.root.join("..", "spec", "fixtures", "fgdc", "harvard-g7064-s2-1834-k3.xml")) }
  let(:mods) { File.read(Rails.root.join("..", "spec", "fixtures", "mods", "stanford-cg357zz0321.mods")) }

  before do
    allow(Faraday).to receive(:new).and_call_original
    stub_metadata_request("https://raw.githubusercontent.com/OpenGeoMetadata/edu.stanford.purl/master/cg/357/zz/0321/iso19139.xml", iso19139)
    stub_metadata_request("https://raw.githubusercontent.com/OpenGeoMetadata/edu.harvard/master/217/121/227/77/fgdc.xml", fgdc)
    stub_metadata_request("http://purl.stanford.edu/cg357zz0321.mods", mods)
  end

  it "renders FGDC metadata as HTML" do
    get metadata_solr_document_path("harvard-g7064-s2-1834-k3")

    expect(response_page).to have_css(".pill-metadata", text: "FGDC")
    expect(response_page).to have_css("dt", text: "Identification Information")
    expect(response_page).to have_css("dt", text: "Metadata Reference Information")
  end

  context "when the metadata is XML" do
    let(:mods) { File.read(Rails.root.join("..", "spec", "fixtures", "mods", "fb897vt9938.mods")) }

    before do
      stub_metadata_request("http://purl.stanford.edu/fb897vt9938.mods", mods)
    end

    it "renders syntax-highlighted MODS" do
      get metadata_solr_document_path("stanford-cg357zz0321")

      expect(response_page).to have_css(".pill-metadata", text: "MODS")
      expect(response_page).to have_css(".CodeRay")
    end
  end

  def stub_metadata_request(url, body)
    response = instance_double(Faraday::Response, body: body, status: 200)
    connection = instance_double(Faraday::Connection, get: response)
    allow(Faraday).to receive(:new).with(url: url).and_return(connection)
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Metadata tool", js: true do
  let(:fgdc) { File.read(Rails.root.join("..", "spec", "fixtures", "fgdc", "harvard-g7064-s2-1834-k3.xml")) }
  let(:response) { instance_double(Faraday::Response, body: fgdc, status: 200) }
  let(:connection) { instance_double(Faraday::Connection, get: response) }

  before do
    allow(Faraday).to receive(:new).and_call_original
    allow(Faraday).to receive(:new)
      .with(url: "https://raw.githubusercontent.com/OpenGeoMetadata/edu.harvard/master/217/121/227/77/fgdc.xml")
      .and_return(connection)
  end

  scenario "opens metadata in a modal" do
    visit solr_document_path("harvard-g7064-s2-1834-k3")

    click_link "Metadata"

    using_wait_time 15 do
      within ".modal-content" do
        expect(page).to have_css(".metadata-view")
        expect(page).to have_css(".pill-metadata", text: "FGDC")
        expect(page).to have_css("dt", text: "Identification Information")
      end
    end
  end
end

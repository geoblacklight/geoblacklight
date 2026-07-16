# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Document relations", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  it "renders source ancestors" do
    get relations_solr_document_path("nyu_2451_34502")

    expect(response_page).to have_css(".relations .card-header h2", text: "Source records...")
  end

  it "renders source descendants" do
    get relations_solr_document_path("nyu_2451_34635")

    expect(response_page).to have_css(".relations .card-header h2", text: "Derived records...")
  end

  it "returns relations as JSON" do
    get relations_solr_document_path("nyu_2451_34635", format: :json)

    json = response.parsed_body
    expect(json["relations"]).not_to have_key("source_ancestors")
    expect(json.dig("relations", "source_descendants", "docs", 0, Geoblacklight.configuration.fields.id)).to eq("nyu_2451_34502")
    expect(json["current_doc"]).to eq("nyu_2451_34635")
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Catalog show page", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  it "shows the data dictionary tool when a reference is present" do
    get solr_document_path("nyu_2451_34502")

    expect(response_page).to have_css("li.data_dictionary a", text: "Documentation")
  end

  it "omits the data dictionary tool when no reference is present" do
    get solr_document_path("stanford-cg357zz0321")

    expect(response_page).to have_no_css("li.data_dictionary a", text: "Documentation")
  end

  it "renders the oEmbed viewer hooks" do
    get solr_document_path("stanford-dc482zx1528")

    expect(response_page).to have_css("#oembed-viewer")
    expect(response_page).to have_css('[data-controller="oembed-viewer"]')
  end

  it "renders the configured metadata fields" do
    get solr_document_path("stanford-dp018hs9766")

    metadata = response_page.find(".document-metadata")
    expect(metadata).to have_css("dt", count: 16)
    expect(metadata).to have_css("dd", count: 20)
    expect(metadata).to have_css("div.truncate-abstract", count: 1)
  end

  it "allows a suppressed record to be viewed" do
    get solr_document_path("princeton-jq085m62x")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("#document")
  end

  it "omits the metadata tool when no metadata reference is present" do
    get solr_document_path("mit-f6rqs4ucovjk2")

    expect(response_page).to have_no_css("li.metadata a", text: "Metadata")
  end
end

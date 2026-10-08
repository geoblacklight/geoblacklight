# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::StaticMapComponent, type: :component do
  let(:document) { SolrDocument.new(id: 1) }

  subject(:rendered) do
    render_inline(described_class.new(document: document))
  end

  it "renders a locator map of where the record is" do
    expect(rendered.css("ogm-locator#locator-map")).to be_present
  end

  it "points it at the same endpoint the item viewer reads its own metadata from" do
    map = rendered.css("ogm-locator").first
    expect(map["record-url"]).to eq Rails.application.routes.url_helpers.viewer_solr_document_path(document)
    expect(map["theme"]).to be_nil
  end

  context "when the record has a map-previewable reference" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/actual-polygon1.json"))) }

    it "does not render a locator map" do
      expect(rendered.css("ogm-locator")).to be_empty
    end
  end

  context "when the record has a IIIF-previewable reference only" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/public_iiif_princeton.json"))) }

    it "renders a locator map" do
      expect(rendered.css("ogm-locator#locator-map")).to be_present
    end
  end
end

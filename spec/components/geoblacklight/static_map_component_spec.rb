# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::StaticMapComponent, type: :component do
  let(:document) { SolrDocument.new(id: 1) }

  subject(:rendered) do
    render_inline(described_class.new(document: document))
  end

  before do
    allow(document).to receive(:viewer_protocol).and_return("map")
    allow(Geoblacklight.configuration).to receive(:sidebar_static_map).and_return(["map"])
  end

  context "when the protocol matches the sidebar_static_map setting" do
    it "renders a locator map of where the record is" do
      expect(rendered.css("ogm-locator#locator-map")).to be_present
    end

    it "points it at the same endpoint the item viewer reads its own metadata from" do
      map = rendered.css("ogm-locator").first
      expect(map["record-url"]).to eq Rails.application.routes.url_helpers.viewer_solr_document_path(document)
      expect(map["theme"]).to be_nil
    end
  end
end

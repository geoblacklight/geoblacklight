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
    it "renders the static map" do
      expect(rendered.css("#static-map")).to be_present
    end
  end
end

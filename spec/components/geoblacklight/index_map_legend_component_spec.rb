# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::IndexMapLegendComponent, type: :component do
  let(:document) { instance_double(SolrDocument) }

  context "when the document has an index map" do
    before do
      allow(document).to receive_message_chain(:item_viewer, :index_map).and_return(true)
    end

    it "renders the legend" do
      render_inline(described_class.new(document:))
      expect(page.text.strip).to include "Green tile indicates Map held by collection"
    end
  end

  context "when the document does not have an index map" do
    before do
      allow(document).to receive_message_chain(:item_viewer, :index_map).and_return(false)
    end

    it "does not render" do
      render_inline(described_class.new(document:))
      expect(page.text.strip).to be_empty
    end
  end
end

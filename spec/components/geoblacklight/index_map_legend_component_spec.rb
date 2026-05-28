# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::IndexMapLegendComponent, type: :component do
  let(:document) { instance_double(SolrDocument) }

  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document:))
  end

  context "when the document has an index map" do
    before do
      allow(document).to receive_message_chain(:item_viewer, :index_map).and_return(true)
    end

    it "renders the legend" do
      expect(rendered.text.strip).to include "Green tile indicates Map held by collection"
    end
  end

  context "when the document does not have an index map" do
    before do
      allow(document).to receive_message_chain(:item_viewer, :index_map).and_return(false)
    end

    it "does not render" do
      expect(rendered.text.strip).to be_empty
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::IiifDragDropComponent, type: :component do
  describe "#iiifdragdropcomponet" do
    let(:reference) { instance_double(Geoblacklight::Reference, endpoint: endpoint) }
    let(:item_viewer) { instance_double(Geoblacklight::ItemViewer, iiif_manifest: reference) }
    let(:document) { instance_double(SolrDocument, id: 123, item_viewer: item_viewer) }
    let(:component) { described_class.new(document: document) }
    let(:rendered) { render_inline_to_capybara_node(component) }

    context "does not have viewer_endpoint url" do
      let(:endpoint) { nil }

      it "does not render" do
        expect(component.render?).to be false
      end
    end

    context "has viewer_endpoint url" do
      let(:endpoint) { "https://url.com/manifest.json" }
      it "renders iiif drag and drop icon" do
        expect(component.render?).to be true
        expect(rendered).to have_selector(:css, ".blacklight-icons-iiif-drag-drop")
        expect(rendered).to have_selector(:css, "a[href='https://url.com/manifest.json?manifest=https://url.com/manifest.json']")
      end
    end
  end
end

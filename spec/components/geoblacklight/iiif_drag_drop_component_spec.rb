# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::IiifDragDropComponent, type: :component do
  describe "#iiifdragdropcomponet" do
    let(:references_field) { Geoblacklight.configuration.fields.references }
    let(:document) { SolrDocument.new("id" => 123, references_field => references.to_json) }
    let(:component) { described_class.new(document: document) }

    context "does not have a manifest url" do
      let(:references) { {"http://iiif.io/api/image" => "https://url.com/info.json"} }

      it "does not render" do
        expect(component.render?).to be false
      end
    end

    context "has a manifest url" do
      let(:references) { {"http://iiif.io/api/presentation#manifest" => "https://url.com/manifest.json"} }

      it "renders iiif drag and drop icon" do
        render_inline(component)
        expect(component.render?).to be true
        expect(page).to have_selector(:css, ".blacklight-icons-iiif-drag-drop")
        expect(page).to have_selector(:css, "a[href='https://url.com/manifest.json?manifest=https://url.com/manifest.json']")
      end
    end
  end
end

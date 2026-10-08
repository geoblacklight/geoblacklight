# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::IiifDragDropComponent, type: :component do
  describe "#iiifdragdropcomponet" do
    let(:document) { SolrDocument.new("id" => 123, Settings.FIELDS.REFERENCES => references.to_json) }
    let(:component) { described_class.new(document: document) }
    let(:rendered) { render_inline_to_capybara_node(component) }

    context "does not have a manifest url" do
      let(:references) { {"http://iiif.io/api/image" => "https://url.com/info.json"} }

      it "does not render" do
        expect(component.render?).to be false
      end
    end

    context "has a manifest url" do
      let(:references) { {"http://iiif.io/api/presentation#manifest" => "https://url.com/manifest.json"} }

      it "renders iiif drag and drop icon" do
        expect(component.render?).to be true
        expect(rendered).to have_selector(:css, ".blacklight-icons-iiif-drag-drop")
        expect(rendered).to have_selector(:css, "a[href='https://url.com/manifest.json?manifest=https://url.com/manifest.json']")
      end
    end
  end
end

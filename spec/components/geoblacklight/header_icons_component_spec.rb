# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::HeaderIconsComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document: document))
  end
  let(:document) { SolrDocument.new(document_attributes) }
  let(:document_attributes) do
    {
      "gbl_resourceClass_sm" => ["Datasets"].to_json,
      "gbl_resourceType_sm" => resource_type_list.to_json,
      "schema_provider_s" => "Stanford",
      "dct_accessRights_s" => "Public"
    }
  end

  context "when there is a resource type with icon" do
    let(:resource_type_list) { ["Polygon"] }
    it "renders 3 icons" do
      puts rendered.native.inner_html.inspect
      expect(rendered).to have_css(".blacklight-icons-polygon")
      expect(rendered).to have_css(".blacklight-icons-stanford")
      expect(rendered).to have_css(".blacklight-icons-public")
    end
  end

  context "when there is a resource type without icon" do
    let(:resource_type_list) { ["Index Maps"] }
    it "renders 3 icons" do
      expect(rendered).to have_css(".blacklight-icons-datasets")
      expect(rendered).to have_css(".blacklight-icons-stanford")
      expect(rendered).to have_css(".blacklight-icons-public")
    end
  end

  context "when the resource type is nil" do
    let(:resource_type_list) { [nil] }
    it "renders 3 icons without errors" do
      expect(rendered).to have_css(".blacklight-icons-datasets")
      expect(rendered).to have_css(".blacklight-icons-stanford")
      expect(rendered).to have_css(".blacklight-icons-public")
    end
  end
end

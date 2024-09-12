# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::HeaderIconsComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document: document))
  end

  let(:document) { SolrDocument.new(document_attributes) }
  let(:resource_class) { [] }
  let(:resource_type) { [] }
  let(:document_attributes) do
    {
      "gbl_resourceClass_sm" => resource_class,
      "gbl_resourceType_sm" => resource_type,
      "schema_provider_s" => "Stanford",
      "dct_accessRights_s" => "Public"
    }
  end

  it "renders the provider icon" do
    expect(rendered).to have_css(".blacklight-icons-stanford")
  end

  it "renders the access rights icon" do
    expect(rendered).to have_css(".blacklight-icons-public")
  end

  context "when there are no resource types with icons" do
    let(:resource_class) { ["Datasets"] }
    let(:resource_type) { ["Census data", "Statistical maps"] }

    it "renders the resource class icon" do
      expect(rendered).to have_css(".blacklight-icons-datasets")
    end
  end

  context "when there is a 'data' resource type with an icon" do
    let(:resource_class) { ["Datasets"] }
    let(:resource_type) { ["Raster data"] }

    it "renders the resource type icon" do
      expect(rendered).to have_css(".blacklight-icons-raster")
    end
  end

  context "when there are multiple resource types and one has an icon" do
    let(:resource_class) { ["Datasets"] }
    let(:resource_type) { ["Nautical charts", "Raster data"] }

    it "renders the resource type that has an icon" do
      expect(rendered).to have_css(".blacklight-icons-raster")
    end
  end
end

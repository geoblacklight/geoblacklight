# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ArcGisComponent, type: :component do
  let(:component) { described_class.new(document: document, action: nil) }
  subject(:rendered) do
    render_inline_to_capybara_node(component)
  end
  let(:document) { instance_double(SolrDocument, id: 123, arcgis_urls: ["https://www.stanford.edu"]) }

  it "shows link" do
    expect(rendered).to have_css("a[href='#{Settings.ARCGIS_BASE_URL}?urls=https%3A%2F%2Fwww.stanford.edu']", text: "Open in ArcGIS Online")
  end

  describe "#arcgis_link" do
    context "single url" do
      it "creates a single url param" do
        expect(component.arcgis_link).to eq "#{Settings.ARCGIS_BASE_URL}?urls=https%3A%2F%2Fwww.stanford.edu"
      end
    end

    context "multiple urls" do
      let(:document) { instance_double(SolrDocument, id: 123, arcgis_urls: ["http://example.com/foo/MapServer", "http://example.com/foo/FeatureServer"]) }

      it "appends the url params" do
        expect(component.arcgis_link).to eq "#{Settings.ARCGIS_BASE_URL}?urls=http%3A%2F%2Fexample.com%2Ffoo%2FMapServer&urls=http%3A%2F%2Fexample.com%2Ffoo%2FFeatureServer"
      end
    end
  end
end

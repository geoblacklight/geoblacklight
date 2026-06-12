# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::WebServicesComponent, type: :component do
  let(:document) { instance_double(SolrDocument, id: 123, wxs_identifier: "wxs_identifier") }
  let(:ref) { instance_double(Geoblacklight::Reference, type: type, endpoint: "endpoint") }
  let(:component) { described_class.new(document: document, ref: ref) }

  before do
    render_inline(component)
  end

  context "when wms is rendered" do
    let(:type) { "wms" }
    it "shows the web mapping service and layers" do
      expect(page).to have_text("Web Mapping Service (WMS)")
      expect(page).to have_text("WMS layers")
      expect(page).to have_css(".web-services-form")
    end
  end

  context "when wfs is rendered" do
    let(:type) { "wfs" }
    it "shows the web mapping service and typeNames" do
      expect(page).to have_text("Web Feature Service (WFS)")
      expect(page).to have_text("WFS typeNames")
      expect(page).to have_css(".web-services-form")
    end
  end

  context "when iiif is rendered" do
    let(:type) { "iiif" }
    it "shows the service" do
      expect(page).to have_text("International Image Interoperability Framework (IIIF)")
      expect(page).to have_css(".web-services-form")
    end
  end

  context "when non service is passed" do
    let(:type) { "iiif2" }
    it "shows nothing" do
      expect(component.render?).to be false
    end
  end
end

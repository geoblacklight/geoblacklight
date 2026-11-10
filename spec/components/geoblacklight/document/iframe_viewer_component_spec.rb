# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Document::IframeViewerComponent, type: :component do
  let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/hdx-iframe.json"))) }
  let(:iframe_attrs) { {} }

  before do
    render_inline(described_class.new(document:, iframe_attrs:))
  end

  it "passes the url to the iframe" do
    expect(page).to have_css("iframe[src='#{document.references.iframe.endpoint}']")
  end

  it "sets default attributes" do
    expect(page).to have_css("iframe[allowfullscreen]")
  end

  it "renders a link to open the source in a new window" do
    expect(page).to have_css("a[href='https://giscience.github.io/open-access-lens/#/jam']")
  end

  context "with extra attributes" do
    let(:iframe_attrs) { {allowpaymentrequest: true} }

    it "renders them on the iframe" do
      expect(page).to have_css("iframe[allowpaymentrequest]")
    end

    it "keeps the default attributes" do
      expect(page).to have_css("iframe[loading=lazy]")
    end
  end

  context "with a record with no iframe reference" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/actual-papermap1.json"))) }

    it "does not render" do
      expect(page).to have_no_css("#iframe-viewer")
    end
  end
end

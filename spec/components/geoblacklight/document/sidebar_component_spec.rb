# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Document::SidebarComponent, type: :component do
  subject(:component) { described_class.new(presenter: presenter) }

  let(:view_context) { vc_test_controller.view_context }
  let(:presenter) { view_context.document_presenter(document) }
  let(:document) { SolrDocument.new(JSON.parse(read_fixture(fixture))) }

  before do
    allow_any_instance_of(Geoblacklight::Document::DownloadLinksComponent).to receive(:render?).and_return(false)
    allow_any_instance_of(Geoblacklight::LoginLinkComponent).to receive(:render?).and_return(false)

    allow(document).to receive(:more_like_this).and_return([])
    allow_any_instance_of(Blacklight::DocumentHelperBehavior).to receive(:current_bookmarks).and_return([])

    with_controller_class(CatalogController) do
      allow(vc_test_controller).to receive_messages(current_or_guest_user: User.new)
      render_inline(component)
    end
  end

  context "when the document viewer protocol is IIIF" do
    let(:fixture) { "solr_documents/public_iiif_princeton.json" }

    it "renders the static map" do
      expect(page).to have_css("#static-map")
    end

    it "renders the Location label" do
      expect(page).to have_content("Location")
    end
  end

  context "when the document viewer protocol is WMS" do
    let(:fixture) { "solr_documents/restricted-line.json" }

    it "does not render the static map" do
      expect(page).to have_no_css("#static-map")
    end

    it "does not render the Location label" do
      expect(page).to have_no_content("Location")
    end
  end
end

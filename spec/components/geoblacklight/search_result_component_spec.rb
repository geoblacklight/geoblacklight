# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::SearchResultComponent, type: :component do
  let(:request_context) { double(document_index_view_type: "list", action_name: :index) }
  let(:blacklight_config) { Blacklight::Configuration.new }
  let(:presenter) do
    Blacklight::DocumentPresenter.new(document, request_context, blacklight_config)
  end

  let(:document) { SolrDocument.new(id: 1, dct_description_sm: description) }
  let(:description) { [] }

  before do
    allow_any_instance_of(BlacklightHelper).to receive(:link_to_document) do |_instance, _doc, value = nil, *|
      value
    end
    allow_any_instance_of(GeoblacklightHelper).to receive(:blacklight_config).and_return(blacklight_config)
    render_inline(described_class.new(document: presenter))
  end

  describe "#description" do
    it "does not render a description block when there is no description" do
      expect(page).to have_no_css(".truncate-abstract")
    end

    context "when the document has a description" do
      let(:description) { ["First paragraph.", "Second paragraph."] }

      it "renders each description value as its own paragraph" do
        expect(page).to have_css(".truncate-abstract p", count: 2)
        expect(page).to have_content("First paragraph.")
        expect(page).to have_content("Second paragraph.")
      end

      it "sets up the truncation data attributes for the JS initializer" do
        expect(page).to have_css(
          ".truncate-abstract[data-max-lines='4'][data-read-more-text='Read more'][data-close-text='Close']"
        )
      end

      it "exposes the description as schema.org markup" do
        expect(page).to have_css(".truncate-abstract[itemprop='description']")
      end
    end
  end

  describe "thumbnails" do
    let(:blacklight_config) do
      Blacklight::Configuration.new.configure do |config|
        config.index.thumbnail_method = :geoblacklight_thumbnail
        config.index.default_thumbnail = :geoblacklight_default_thumbnail
      end
    end
    let(:presenter) do
      Blacklight::IndexPresenter.new(document, request_context, blacklight_config)
    end

    context "when a thumbnail is available" do
      let(:request_context) do
        double(document_index_view_type: "list", action_name: :index,
          geoblacklight_thumbnail: '<img src="http://example.com/thumb.jpg" alt="">'.html_safe)
      end

      it "renders the thumbnail image" do
        expect(page).to have_css ".document-thumbnail img[src='http://example.com/thumb.jpg']"
      end
    end

    context "when no thumbnail is available but a default exists" do
      let(:request_context) do
        double(document_index_view_type: "list", action_name: :index,
          geoblacklight_thumbnail: nil,
          geoblacklight_default_thumbnail: '<span class="blacklight-icons"></span>'.html_safe)
      end

      it "renders the default thumbnail" do
        expect(page).to have_css ".document-thumbnail .blacklight-icons"
      end
    end

    context "when neither a thumbnail nor a default is available" do
      let(:request_context) do
        double(document_index_view_type: "list", action_name: :index,
          geoblacklight_thumbnail: nil, geoblacklight_default_thumbnail: nil)
      end

      it "does not render a thumbnail" do
        expect(page).not_to have_css ".document-thumbnail"
      end
    end
  end
end

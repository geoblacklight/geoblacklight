# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Relations::RelationComponent, type: :component do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:description) { [] }
  let(:document_attributes) do
    {
      "id" => "related-doc",
      "dct_title_s" => "A Related Record",
      "dct_description_sm" => description
    }
  end

  describe "rendering the related document" do
    before { render_inline(described_class.new(document: document)) }

    it "links to the related document's show page" do
      expect(page).to have_link("A Related Record", href: Rails.application.routes.url_helpers.solr_document_path(document))
    end

    it "renders the document's status icon badges" do
      expect(page).to have_css(".badges")
    end

    it "does not render a description block when there is no description" do
      expect(page).to have_no_css(".truncate-abstract")
    end

    it "does not render a sibling browse link when no sibling_count is given" do
      expect(page).to have_no_css("a.browse-all")
    end
  end

  context "when the document has a description" do
    let(:description) { ["First paragraph.", "Second paragraph."] }

    before { render_inline(described_class.new(document: document)) }

    it "renders each description value as its own paragraph" do
      expect(page).to have_css(".truncate-abstract p", count: 2)
      expect(page).to have_content("First paragraph.")
      expect(page).to have_content("Second paragraph.")
    end

    it "sets up the truncation data attributes for the JS initializer" do
      expect(page).to have_css(
        ".truncate-abstract[data-max-lines='5'][data-read-more-text='Read more'][data-close-text='Close']"
      )
    end
  end

  context "when sibling_count is nil (not an ancestor relationship)" do
    before do
      render_inline(described_class.new(document: document, field: "dct_isPartOf_sm", sibling_count: nil, browse_label_key: "part_of"))
    end

    it "does not render a sibling browse link" do
      expect(page).to have_no_css("a.browse-all")
    end
  end

  context "when sibling_count is zero (the ancestor reference doesn't resolve to anything)" do
    before do
      render_inline(described_class.new(document: document, field: "dct_isPartOf_sm", sibling_count: 0, browse_label_key: "part_of"))
    end

    it "does not render a sibling browse link" do
      expect(page).to have_no_css("a.browse-all")
    end
  end

  context "when sibling_count is one (the current document is the only one that matches)" do
    before do
      render_inline(described_class.new(document: document, field: "dct_isPartOf_sm", sibling_count: 1, browse_label_key: "part_of"))
    end

    it "does not render a sibling browse link, since the search would only return this document" do
      expect(page).to have_no_css("a.browse-all")
    end
  end

  context "when sibling_count is greater than one" do
    before do
      render_inline(described_class.new(document: document, field: "dct_isPartOf_sm", sibling_count: 4, browse_label_key: "part_of"))
    end

    it "renders a sibling browse link scoped to this document's id on the given field" do
      expected_href = Rails.application.routes.url_helpers.search_catalog_path(f: {"dct_isPartOf_sm" => ["related-doc"]})
      expect(page).to have_css("a.browse-all[href='#{expected_href}']")
    end

    it "renders the browse link text from the browse_label_key locale scope, matching the search's true total" do
      expect(page).to have_link(I18n.t("geoblacklight.relations.browse.part_of", count: 4), class: "browse-all")
    end
  end
end

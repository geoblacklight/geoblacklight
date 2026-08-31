# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Relations::RelationsComponent, type: :component do
  let(:repository) { Blacklight::Solr::Repository.new(CatalogController.blacklight_config) }
  let(:relations) { Geoblacklight::Relations::RelationResponse.new(id, repository) }
  let(:rel_type_info) { Geoblacklight.configuration.relationships_shown[relationship_type] }
  let(:component) { described_class.new(relations: relations, relationship_type: relationship_type, rel_type_info: rel_type_info) }

  describe "#render?" do
    context "with a document that has matching relations" do
      let(:id) { "nyu_2451_34502" }
      let(:relationship_type) { :source_ancestors }

      it "is true" do
        expect(component.render?).to be true
      end
    end

    context "with a document that has no matching relations" do
      let(:id) { "berkeley-s7pq31" }
      let(:relationship_type) { :source_ancestors }

      it "is false, so the component renders nothing" do
        expect(component.render?).to be false
      end
    end
  end

  describe "#browse_label_key" do
    let(:id) { "nyu_2451_34502" }

    it "strips the _ancestors suffix" do
      expect(described_class.new(relations: relations, relationship_type: :part_of_ancestors, rel_type_info: Geoblacklight.configuration.relationships_shown.part_of_ancestors).browse_label_key).to eq("part_of")
    end

    it "strips the _descendants suffix" do
      expect(described_class.new(relations: relations, relationship_type: :part_of_descendants, rel_type_info: Geoblacklight.configuration.relationships_shown.part_of_descendants).browse_label_key).to eq("part_of")
    end
  end

  describe "#sibling_count" do
    context "for an ancestor relationship" do
      let(:relationship_type) { :source_ancestors }

      context "when the current document is the only one that shares this ancestor" do
        let(:id) { "nyu_2451_34502" }
        let(:ancestor) { SolrDocument.new("id" => "nyu_2451_34636") }

        it "counts just the current document itself" do
          expect(component.sibling_count(ancestor)).to eq(1)
        end
      end

      context "when other documents also share this ancestor" do
        let(:id) { "757d0f6e-2e04-4ac1-bd28-a5204df46ac1" }
        let(:relationship_type) { :part_of_ancestors }
        let(:ancestor) { SolrDocument.new("id" => "eee6150b-ce2f-4837-9d17-ce72a0c1c26f") }

        it "returns the total number of documents that share that ancestor, including this one" do
          expect(component.sibling_count(ancestor)).to eq(4)
        end
      end

      context "with an ancestor id containing Solr special characters" do
        let(:id) { "nyu_2451_34502" }
        let(:ancestor) { SolrDocument.new("id" => "ark:/12345/x6") }

        it "escapes the id instead of raising" do
          expect { component.sibling_count(ancestor) }.not_to raise_error
          expect(component.sibling_count(ancestor)).to be_a(Integer)
        end
      end
    end

    context "for a descendant relationship" do
      let(:id) { "nyu_2451_34502" }
      let(:relationship_type) { :source_descendants }
      let(:ancestor) { SolrDocument.new("id" => "nyu_2451_34636") }

      it "returns nil, since there is nothing to browse to from a descendant" do
        expect(component.sibling_count(ancestor)).to be_nil
      end
    end
  end

  describe "rendering" do
    context "when there are 3 or fewer related documents" do
      let(:id) { "nyu_2451_34502" }
      let(:relationship_type) { :source_ancestors }

      before { render_inline(component) }

      it "renders the pluralized relationship label with the result count" do
        expect(page).to have_css(".card-header h2", text: "Sourced from 2 items")
      end

      it "renders one row per related document" do
        expect(page).to have_css(".list-group-item", count: 2)
      end

      it "does not render a browse-all footer" do
        expect(page).to have_no_css(".card-footer")
      end
    end

    context "when there are more than 3 related documents, but the relationship is an ancestor relationship" do
      # browse_all_path always filters on the current document's own id, which only finds
      # results for descendant relationships - there's no fixture with >3 real ancestors of
      # one type, so the scenario is forced here to prove the footer is suppressed rather
      # than linking to a query that would return the wrong (or zero) results.
      let(:id) { "nyu_2451_34502" }
      let(:relationship_type) { :source_ancestors }

      before do
        allow(component).to receive(:result_count).and_return(5)
        render_inline(component)
      end

      it "does not render a browse-all footer, since browse_all_path would search the wrong direction" do
        expect(page).to have_no_css(".card-footer")
      end
    end

    context "when there are more than 3 related documents" do
      let(:id) { "eee6150b-ce2f-4837-9d17-ce72a0c1c26f" }
      let(:relationship_type) { :part_of_descendants }

      before { render_inline(component) }

      it "renders the pluralized relationship label with the result count" do
        expect(page).to have_css(".card-header h2", text: "Has 4 parts")
      end

      it "renders only the first 3 related documents" do
        expect(page).to have_css(".list-group-item", count: 3)
      end

      it "renders a browse-all footer linking to the rest of the results" do
        expected_href = Rails.application.routes.url_helpers.search_catalog_path(f: {"dct_isPartOf_sm" => ["eee6150b-ce2f-4837-9d17-ce72a0c1c26f"]})
        expect(page).to have_css(".card-footer a[href='#{expected_href}']", text: "Browse all 4 parts of this item")
      end
    end
  end
end

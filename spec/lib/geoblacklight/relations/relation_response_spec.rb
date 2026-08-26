# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Relations::RelationResponse do
  let(:repository) { Blacklight::Solr::Repository.new(CatalogController.blacklight_config) }
  let(:relation_resp) { described_class.new("nyu_2451_34502", repository) }

  describe "#initialize" do
    it "creates a RelationResponse" do
      expect(relation_resp).to be_an described_class
    end

    it "exposes the repository it was built with" do
      expect(relation_resp.repository).to eq(repository)
    end

    it "exposes the unescaped id as link_id" do
      expect(relation_resp.link_id).to eq("nyu_2451_34502")
    end

    context "with an id containing Solr special characters" do
      let(:relation_resp) { described_class.new("ark:/12345/x6", repository) }

      it "keeps link_id unescaped, for display and API responses" do
        expect(relation_resp.link_id).to eq("ark:/12345/x6")
      end

      it "escapes search_id, for building Solr filter queries" do
        expect(relation_resp.search_id).to eq(RSolr.solr_escape("ark:/12345/x6"))
        expect(relation_resp.search_id).not_to eq("ark:/12345/x6")
      end
    end
  end

  describe "#method_missing" do
    it "returns a hash of ancestor documents" do
      expect(relation_resp.source_ancestors).to include("numFound")
      expect(relation_resp.source_ancestors).to include("docs")
    end

    it "returns a hash of descendant documents" do
      expect(relation_resp.source_descendants).to include("numFound")
      expect(relation_resp.source_descendants).to include("docs")
    end

    it "raises NoMethodError for an unconfigured relationship" do
      expect { relation_resp.FAIL }.to raise_error NoMethodError
    end
  end

  describe "#respond_to_missing?" do
    it "returns true for configured relationships" do
      Geoblacklight.configuration.relationships_shown.each_key do |key|
        expect(relation_resp).to respond_to(key)
      end
    end

    it "returns false for non-configured options" do
      expect(relation_resp).not_to respond_to("FAIL")
    end
  end

  describe "#query_type" do
    it "fails for a bad query type request" do
      relationships = Geoblacklight.configuration.relationships_shown
      Geoblacklight.configuration.relationships_shown = Geoblacklight::Configuration::RelationshipsConfig.new(
        BAD: {field: "dct_source_sm", query_type: "bad_query_type", label: "geoblacklight.relations.source_ancestors"}
      )

      expect { relation_resp.BAD }.to raise_error(ArgumentError)
    ensure
      Geoblacklight.configuration.relationships_shown = relationships
    end
  end
end

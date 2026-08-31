# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Relations::Descendants do
  let(:repository) { Blacklight::Solr::Repository.new(CatalogController.blacklight_config) }
  let(:descendants) { described_class.new("nyu_2451_34636", Geoblacklight.configuration.fields.source, repository) }
  let(:empty_descendants) do
    described_class.new("berkeley-s7pq31", Geoblacklight.configuration.fields.source, repository)
  end

  describe "#create_search_params" do
    it "assembles the correct search params for finding descendant documents" do
      expect(descendants.create_search_params).to eq(
        fq: "#{Geoblacklight.configuration.fields.source}:nyu_2451_34636",
        rows: 3,
        fl: [
          Geoblacklight.configuration.fields.title, Geoblacklight.configuration.fields.id,
          Geoblacklight.configuration.fields.resource_type, Geoblacklight.configuration.fields.description,
          Geoblacklight.configuration.fields.resource_class, Geoblacklight.configuration.fields.access_rights
        ]
      )
    end
  end

  describe "#execute_query" do
    it "executes the query for finding descendants, return response" do
      expect(descendants.execute_query).to include("responseHeader")
    end
  end

  describe "#results" do
    it "produces a hash of results from the query" do
      expect(descendants.results).to include("numFound")
      expect(descendants.results).to include("docs")
    end

    it "has non-zero numFound for a document with descendants" do
      expect(descendants.results["numFound"]).to be > 0
    end

    it "has zero numFound for a document without descendants" do
      expect(empty_descendants.results["numFound"]).to eq(0)
    end
  end
end

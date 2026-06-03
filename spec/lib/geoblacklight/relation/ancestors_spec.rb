# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::Relation::Ancestors do
  let(:repository) { Blacklight::Solr::Repository.new(CatalogController.blacklight_config) }
  let(:ancestors) { described_class.new("nyu_2451_34502", Geoblacklight.configuration.fields.source, repository) }
  let(:empty_ancestors) do
    described_class.new("harvard-g7064-s2-1834-k3", Geoblacklight.configuration.fields.source, repository)
  end

  describe "#create_search_params" do
    it "assembles the correct search params for finding ancestor documents" do
      expect(ancestors.create_search_params).to eq(
        fq: ["{!join from=#{Geoblacklight.configuration.fields.source} to=#{Geoblacklight.configuration.fields.id}}#{Geoblacklight.configuration.fields.id}:nyu_2451_34502"], fl: [
          Geoblacklight.configuration.fields.title, Geoblacklight.configuration.fields.id, Geoblacklight.configuration.fields.resource_type
        ]
      )
    end
  end

  describe "#execute_query" do
    it "executes the query for finding ancestors, return response" do
      expect(ancestors.execute_query).to include("responseHeader")
    end
  end

  describe "#results" do
    it "produces a hash of results from the query" do
      expect(ancestors.results).to include("numFound")
      expect(ancestors.results).to include("docs")
    end
    it "has non-zero numfound for a document with ancestors" do
      expect(ancestors.results["numFound"]).to be > 0
    end
    it "has zero numfound for a document without ancestors" do
      expect(empty_ancestors.results["numFound"]).to eq(0)
    end
  end
end

require "spec_helper"

RSpec.describe Geoblacklight::Configuration::RelationshipsConfig do
  before do
    allow(Geoblacklight::Deprecation).to receive(:warn)
    Geoblacklight::Configuration::RelationshipConfig.reset_removed_attribute_warnings!
  end

  describe "the defaults" do
    subject(:config) { described_class.new }

    it "carries the twelve relationships, lowercased" do
      expect(config.each_key.to_a).to eq(
        %i[
          member_of_ancestors member_of_descendants
          part_of_ancestors part_of_descendants
          relation_ancestors relation_descendants
          replaces_ancestors replaces_descendants
          source_ancestors source_descendants
          version_of_ancestors version_of_descendants
        ]
      )
    end

    it "builds each entry as a RelationshipConfig" do
      expect(config.map { |_name, entry| entry }).to all(be_a(Geoblacklight::Configuration::RelationshipConfig))
    end

    it "does not warn" do
      config

      expect(Geoblacklight::Deprecation).not_to have_received(:warn)
    end
  end

  describe "a settings file carried over from GeoBlacklight 5" do
    # Verbatim from the config/settings.yml that GeoBlacklight 4.0 and later wrote:
    # uppercase entry names, an uppercase inverse, and an icon on every entry.
    subject(:config) do
      described_class.new(
        MEMBER_OF_ANCESTORS: {
          field: "pcdm_memberOf_sm",
          icon: "parent-item",
          inverse: :MEMBER_OF_DESCENDANTS,
          label: "geoblacklight.relations.member_of_ancestors",
          query_type: "ancestors"
        },
        MEMBER_OF_DESCENDANTS: {
          field: "pcdm_memberOf_sm",
          icon: "child-item",
          inverse: :MEMBER_OF_ANCESTORS,
          label: "geoblacklight.relations.member_of_descendants",
          query_type: "descendants"
        }
      )
    end

    it "builds without raising" do
      expect { config }.not_to raise_error
    end

    it "lowercases the entry names" do
      expect(config.each_key.to_a).to eq(%i[member_of_ancestors member_of_descendants])
    end

    it "keeps the rest of each entry intact" do
      expect(config[:member_of_ancestors].field).to eq("pcdm_memberOf_sm")
      expect(config[:member_of_ancestors].query_type).to eq("ancestors")
      expect(config[:member_of_ancestors].label).to eq("geoblacklight.relations.member_of_ancestors")
    end

    it "warns once about the icons rather than once per entry" do
      config

      expect(Geoblacklight::Deprecation).to have_received(:warn).once.with(/icon/)
    end

    # RelationsComponent builds each card's "Browse all ..." link from the entry
    # name, and its regexp only matches the lowercase form. Left uppercase, the
    # link renders as a titleized key instead of a sentence.
    it "produces names that RelationsComponent can derive a browse label from" do
      browse_keys = config.each_key.map { |name| name.to_s.sub(/_(ancestors|descendants)\z/, "") }

      expect(browse_keys).to eq(%w[member_of member_of])
    end
  end

  describe "lookup" do
    subject(:config) { described_class.new(MEMBER_OF_ANCESTORS: {field: "pcdm_memberOf_sm"}) }

    it "finds a normalized name with #[]" do
      expect(config[:member_of_ancestors].field).to eq("pcdm_memberOf_sm")
    end

    it "reports a normalized name with #key?" do
      expect(config.key?(:member_of_ancestors)).to be true
      expect(config.key?(:MEMBER_OF_ANCESTORS)).to be false
    end

    it "answers a normalized name as a method" do
      expect(config.member_of_ancestors.field).to eq("pcdm_memberOf_sm")
    end

    it "still raises NoMethodError for a name it does not have" do
      expect { config.no_such_relationship }.to raise_error(NoMethodError)
    end
  end

  describe "an unrecognized key" do
    it "raises, naming the file and the key" do
      expect { described_class.new(member_of_ancestors: {field: "x", quiery_type: "ancestors"}) }
        .to raise_error(Geoblacklight::Exceptions::InvalidSettings, /"quiery_type"/)
    end
  end

  it "passes an already-built RelationshipConfig through untouched" do
    entry = Geoblacklight::Configuration::RelationshipConfig.new(field: "pcdm_memberOf_sm")

    expect(described_class.new(member_of_ancestors: entry)[:member_of_ancestors]).to be(entry)
  end
end

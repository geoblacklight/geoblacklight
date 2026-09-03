require "spec_helper"

RSpec.describe Geoblacklight::Configuration::SettingsAttributes do
  # Exercised through the two real classes that include it rather than a stub, so
  # these also cover the wiring in each class.
  shared_examples "a settings-backed value object" do |section:|
    it "declares the settings.yml section it is built from" do
      expect(described_class.settings_section).to eq(section)
    end

    it "resolves an uppercase key to its lowercase attribute" do
      attribute = described_class.attribute_names.first

      expect(described_class.new(attribute.upcase.to_sym => "a value").public_send(attribute)).to eq("a value")
    end

    it "assigns recognized attributes without complaint" do
      attributes = described_class.attribute_names.to_h { |name| [name.to_sym, "a value"] }

      expect { described_class.new(attributes) }.not_to raise_error
    end

    it "raises for an unrecognized key, naming the section and what is accepted" do
      expect { described_class.new(no_such_key: "a value") }.to raise_error(
        Geoblacklight::Exceptions::InvalidSettings,
        /#{section}.*"no_such_key".*#{Regexp.escape(described_class.attribute_names.join(", "))}/m
      )
    end

    # ActiveModel::AttributeAssignment defines a raising attribute_writer_missing.
    # If SettingsAttributes is ever included before ActiveModel -- for instance by
    # rewriting it as an ActiveSupport::Concern that includes ActiveModel itself --
    # ActiveModel's version wins and every example above starts failing for a
    # reason that has nothing to do with the behavior being tested.
    it "installs its override ahead of ActiveModel's raising default" do
      expect(described_class.instance_method(:attribute_writer_missing).owner)
        .to eq(Geoblacklight::Configuration::SettingsAttributes)
    end
  end

  describe Geoblacklight::Configuration::RelationshipConfig do
    before do
      allow(Geoblacklight::Deprecation).to receive(:warn)
      described_class.reset_removed_attribute_warnings!
    end

    it_behaves_like "a settings-backed value object", section: "RELATIONSHIPS_SHOWN"

    it "treats icon as removed" do
      expect(described_class.removed_attributes).to eq(%w[icon])
    end

    it "builds successfully from a verbatim GeoBlacklight 5 entry" do
      config = described_class.new(
        field: "pcdm_memberOf_sm",
        icon: "parent-item",
        inverse: :member_of_descendants,
        label: "geoblacklight.relations.member_of_ancestors",
        query_type: "ancestors"
      )

      expect(config.field).to eq("pcdm_memberOf_sm")
      expect(config.query_type).to eq("ancestors")
    end

    it "does not carry the removed attribute" do
      expect(described_class.attribute_names).not_to include("icon")
    end

    it "warns that icon is no longer read" do
      described_class.new(icon: "parent-item")

      expect(Geoblacklight::Deprecation).to have_received(:warn).with(/icon.*RELATIONSHIPS_SHOWN/)
    end

    it "warns about an uppercase removed attribute too" do
      described_class.new({ICON: "parent-item"})

      expect(Geoblacklight::Deprecation).to have_received(:warn).with(/icon/)
    end

    it "warns only once however many entries set it" do
      12.times { described_class.new(field: "pcdm_memberOf_sm", icon: "parent-item") }

      expect(Geoblacklight::Deprecation).to have_received(:warn).once
    end

    it "does not warn when no removed attribute is set" do
      described_class.new(field: "pcdm_memberOf_sm")

      expect(Geoblacklight::Deprecation).not_to have_received(:warn)
    end
  end

  describe Geoblacklight::Configuration::DisplayNoteShownConfig do
    before { allow(Geoblacklight::Deprecation).to receive(:warn) }

    it_behaves_like "a settings-backed value object", section: "DISPLAY_NOTES_SHOWN"

    it "has no removed attributes" do
      expect(described_class.removed_attributes).to be_empty
    end

    # icon means opposite things in the two classes: RelationshipConfig drops it,
    # while here it is a real attribute that has to survive.
    it "keeps icon, which is one of its own attributes" do
      config = described_class.new(icon: "circle-info-solid", note_prefix: "Info: ")

      expect(config.icon).to eq("circle-info-solid")
      expect(Geoblacklight::Deprecation).not_to have_received(:warn)
    end
  end
end

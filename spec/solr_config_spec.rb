# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Solr configuration" do
  def parse(name)
    Nokogiri::XML(File.read(File.expand_path("../solr/conf/#{name}", __dir__)))
  end

  let(:schema) { parse("schema.xml") }
  let(:solrconfig) { parse("solrconfig.xml") }

  # Every *_ti and *_tmi name matches a dynamicField, so boosting a field that no
  # copyField populates is legal, queryable, and always empty -- Solr never
  # complains, the boost just silently contributes nothing to scoring. That has
  # happened twice now: renaming a copyField destination from *_ti to *_tmi
  # (multiValued sources need multiValued destinations) left the matching qf/pf
  # entry behind. Deliberately ignores dynamicFields, since resolving through one
  # is exactly the bug being guarded against.
  def populated_fields
    schema.xpath("//fields/field/@name").map(&:value) +
      schema.xpath("//copyField/@dest").map(&:value)
  end

  # Reads the /text() children rather than the <str> node's own text, so the XML
  # comment inside <str name="pf"> cannot leak words into the field list.
  def boosted_fields(param)
    solrconfig.xpath("//requestHandler[@name='/select']//str[@name='#{param}']/text()")
      .map(&:text).join(" ")
      .split.map { |entry| entry.split("^").first }
  end

  %w[qf pf].each do |param|
    it "only boosts #{param} fields that something populates" do
      dead = boosted_fields(param) - populated_fields

      expect(dead).to be_empty,
        "#{param} boosts fields no copyField or <field> populates: #{dead.join(", ")}"
    end
  end
end

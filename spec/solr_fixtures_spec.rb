# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Solr fixture documents" do
  def fixture_paths
    Dir[File.expand_path("fixtures/solr_documents/*.json", __dir__)]
  end

  def documents
    fixture_paths.flat_map do |path|
      parsed = JSON.parse(File.read(path))
      Array.wrap(parsed).map { |document| [File.basename(path), document] }
    end
  end

  # Maps the name of each JSON string that repeats a key within an object to the
  # parser's complaint. allow_duplicate_key needs json 2.13 or later; older
  # versions ignore it.
  def repeated_keys(named_json)
    named_json.each_with_object({}) do |(name, json), repeats|
      JSON.parse(json, allow_duplicate_key: false)
    rescue JSON::ParserError => e
      repeats[name] = e.message
    end
  end

  # geoblacklight:index:seed adds these documents to Solr, which upserts on id. Two
  # fixtures sharing an id overwrite one another silently, so the index comes up
  # short and the losing record is simply absent from every spec that expects it.
  it "gives every document a unique id" do
    duplicates = documents.group_by { |_file, document| document["id"] }
      .select { |_id, entries| entries.length > 1 }
      .transform_values { |entries| entries.map(&:first).sort }

    expect(duplicates).to be_empty, "fixtures share an id: #{duplicates.inspect}"
  end

  # json 2 settles a repeated key by keeping the last value, but json 3 raises, so a
  # repeat would make geoblacklight:index:seed fail before indexing anything.
  it "repeats no key within a document" do
    repeats = repeated_keys(fixture_paths.map { |path| [File.basename(path), File.read(path)] })

    expect(repeats).to be_empty, "fixtures repeat a key: #{repeats.inspect}"
  end

  # Geoblacklight::References treats references it cannot parse as absent, so under
  # json 3 a repeated key would quietly cost the record its viewer, downloads and
  # links.
  it "repeats no key within a document's references" do
    field = Geoblacklight.configuration.fields.references
    repeats = repeated_keys(documents.filter_map { |file, document| [file, document[field]] if document[field] })

    expect(repeats).to be_empty, "fixture references repeat a key: #{repeats.inspect}"
  end
end

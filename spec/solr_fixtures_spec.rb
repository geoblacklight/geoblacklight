# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Solr fixture documents" do
  def documents
    Dir[File.expand_path("fixtures/solr_documents/*.json", __dir__)].flat_map do |path|
      parsed = JSON.parse(File.read(path))
      Array.wrap(parsed).map { |document| [File.basename(path), document] }
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
end

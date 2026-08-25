# frozen_string_literal: true

require "spec_helper"

RSpec.feature "xyz layer" do
  scenario "displays xyz layer", js: true do
    visit solr_document_path("6f47b103-9955-4bbe-a364-387039623106-xyz")

    expect(preview_tabs).to include "XYZ Tile Service"
  end
end

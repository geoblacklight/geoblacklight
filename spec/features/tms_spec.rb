# frozen_string_literal: true

require "spec_helper"

RSpec.feature "tms layer" do
  scenario "displays tms layer", js: true do
    visit solr_document_path("cugir-007957")

    expect(preview_tabs).to include "Tiled Map Service (TMS)"
  end
end

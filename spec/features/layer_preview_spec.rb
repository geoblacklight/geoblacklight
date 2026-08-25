# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Layer preview", js: true do
  # A restricted layer offers its location instead, which is spec/features/restricted_viewer_spec.rb
  scenario "Public layer should be previewed as data" do
    visit solr_document_path("mit-f6rqs4ucovjk2")

    expect(preview_tabs).to include "Web Map Service (WMS)"
  end
end

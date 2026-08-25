# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Restricted item viewer", js: true do
  scenario "offers to sign in, and shows where the layer is rather than failing to load it" do
    visit solr_document_path("stanford-dp018hs9766")

    expect(page).to have_link("Login to View and Download")

    # The viewer was handed a record with no service references, so the only preview it can offer
    # is the record's own extent
    previews = find("ogm-viewer").shadow_root.find("ogm-previews", visible: :all)
    expect(previews.shadow_root).to have_css("wa-tab", text: "Location", visible: :all)
  end
end

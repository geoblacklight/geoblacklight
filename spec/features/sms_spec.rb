# frozen_string_literal: true

require "spec_helper"

RSpec.feature "SMS tool", js: true do
  scenario "opens the SMS form in a modal" do
    visit solr_document_path("stanford-cg357zz0321")

    click_link "SMS This"

    within ".modal-content" do
      expect(page).to have_css("h1", text: "SMS This")
      expect(page).to have_css("label", text: "Phone Number:")
      expect(page).to have_css("label", text: "Carrier")
    end
  end
end

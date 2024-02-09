# frozen_string_literal: true

require "spec_helper"

feature "SMS tool", js: true do
  scenario "shows up in tools" do
    visit solr_document_path "stanford-cg357zz0321"
    expect(page).to have_css "li.sms a", text: "SMS This"
    click_link "SMS This"
    within ".modal-body" do
      # See: https://github.com/projectblacklight/blacklight/pull/3120
      skip("@TODO: BL v8.1.0 is missing the SMS/Email bug fix, re-add test after v8.1.0+ is released")
      expect(page).to have_css "input", count: 1
      expect(page).to have_css "label", text: "Phone Number:"
      expect(page).to have_css "select", count: 1
      expect(page).to have_css "label", text: "Carrier"
    end
  end
end

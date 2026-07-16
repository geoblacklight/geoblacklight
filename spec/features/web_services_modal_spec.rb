# frozen_string_literal: true

require "spec_helper"

# Open the web services modal and wait for it to load
def open_web_services_modal
  expect(page).to have_link "Web services"
  click_link "Web services"
  expect(page).to have_css "h1", text: "Web services"
end

RSpec.describe "web services tools", type: :feature do
  context "when any reference is linked" do
    it "copies the link to clipboard", js: true do
      sign_in # NOTE: this seems to be required for clipboard permissions to be granted succesfully
      page.driver.browser.add_permission("clipboard-read", "granted")
      page.driver.browser.add_permission("clipboard-write", "granted")
      visit solr_document_path "princeton-1r66j405w"
      open_web_services_modal
      click_button "Copy"
      clip_text = page.evaluate_async_script("navigator.clipboard.readText().then(arguments[0])")
      expect(clip_text).to include("https://libimages1.princeton.edu/loris/figgy_prod/5a%2F20%2F58%2F5a20585db50d44959fe5ae44821fd174%2Fintermediate_file.jp2/info.json")
    end
  end
end

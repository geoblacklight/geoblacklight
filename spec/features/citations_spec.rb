# frozen_string_literal: true

require "spec_helper"

feature "Blacklight Citation" do
  scenario "citations can be copied", js: true do
    sign_in # NOTE: this seems to be required for clipboard permissions to be granted succesfully
    page.driver.browser.add_permission("clipboard-read", "granted")
    page.driver.browser.add_permission("clipboard-write", "granted")
    visit "/catalog/princeton-1r66j405w"
    click_link "Cite"
    click_button "Copy Citation"
    clip_text = page.evaluate_async_script("navigator.clipboard.readText().then(arguments[0])")
    expect(clip_text).to include("Sanborn Map Company. Princeton, Mercer County, New Jersey.")
  end
end

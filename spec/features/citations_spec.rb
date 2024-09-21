# frozen_string_literal: true

require "spec_helper"

feature "Blacklight Citation", js: true do
  scenario "index has created citations" do
    sign_in
    visit "/catalog/princeton-1r66j405w"
    click_link "Cite"
    page.driver.browser.add_permission("clipboard-read", "granted")
    page.driver.browser.add_permission("clipboard-write", "granted")
    click_button "Copy Citation"
    clip_text = page.evaluate_async_script("navigator.clipboard.readText().then(arguments[0])")
    expect(clip_text).to include("Sanborn Map Company")
  end
end

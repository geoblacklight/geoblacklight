# frozen_string_literal: true

require "spec_helper"

feature "Blacklight Citation" do
  scenario "index has created citations" do
    sign_in
    visit "/catalog/princeton-1r66j405w"
    click_link "Cite"
    expect(page).to have_text "Copy Citation"
  end
end

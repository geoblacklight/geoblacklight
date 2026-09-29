# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Signing in to see a restricted record" do
  let(:restricted) { "stanford-dp018hs9766" }

  scenario "brings the reader back to the record once they're signed in" do
    skip_without_authentication
    visit solr_document_path(restricted)
    click_link "Login to View and Download"
    fill_in_sign_in_form FactoryBot.create(:user)

    expect(page).to have_current_path(solr_document_path(restricted))
    expect(page).to have_link "Log Out"
    expect(page).to have_no_link "Login to View and Download"
  end

  scenario "is not offered when the app has no authentication" do
    skip "the test app has authentication" if AuthenticationHelpers.provider
    visit solr_document_path(restricted)

    expect(page).to have_css "h1", text: "Elkhorn Slough"
    expect(page).to have_no_link "Login to View and Download"
  end
end

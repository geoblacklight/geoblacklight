# frozen_string_literal: true

require "spec_helper"

RSpec.describe "SMS form", type: :request do
  it "renders the phone number and carrier fields" do
    get sms_solr_document_path("stanford-cg357zz0321")

    page = Capybara.string(response.body)
    expect(page).to have_css("label", text: "Phone Number:", visible: :all)
    expect(page).to have_css("select", count: 1, visible: :all)
    expect(page).to have_css("label", text: "Carrier", visible: :all)
  end
end

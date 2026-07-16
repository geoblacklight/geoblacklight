# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Bookmarks", type: :request do
  it "lists a newly created bookmark" do
    post bookmarks_path, params: {id: "harvard-g7064-s2-1834-k3"}
    get bookmarks_path

    page = Capybara.string(response.body)
    expect(page).to have_css(".document", count: 1)
  end
end

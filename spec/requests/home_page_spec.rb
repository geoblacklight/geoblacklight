# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Home page", type: :request do
  def response_page
    Capybara.string(response.body)
  end

  it "renders the home search and feature facets" do
    get root_path

    expect(response_page).to have_no_css("#search-navbar")
    expect(response_page).to have_css("h1", text: "Explore and discover...")
    expect(response_page).to have_css("h2", text: "Find the maps and data you need")
    expect(response_page).to have_css("form.search-query-form")
    expect(response_page).to have_css(".category-block", count: 4)
    expect(response_page).to have_css(".home-facet-link", count: 36)
    expect(response_page).to have_css("a.more_facets_link", count: 4)
  end

  it "links feature facets to filtered results" do
    get root_path
    get response_page.find_link("Counties")[:href]

    expect(response_page).to have_css(".filter-name", text: "Subject")
    expect(response_page).to have_css(".filter-value", text: "Counties")
  end

  it "links placenames to their results" do
    get root_path
    get response_page.find_link("New York, New York")[:href]

    expect(response_page).to have_css("article.document", count: 4)
  end

  it "exposes the GeoBlacklight version" do
    get root_path

    expect(response_page).to have_css("#geoblacklight-version")
  end
end

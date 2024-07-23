# frozen_string_literal: true

require "spec_helper"

feature "search results display document iconography" do
  scenario "when viewing result row" do
    # Search returns fixture stanford-cg357zz0321
    visit search_catalog_path(
      search_field: "all_fields",
      q: "stanford-cg357zz0321"
    )
    first_result = page.all("span.status-icons > span")
    expect(first_result[0][:class]).to include "blacklight-icons-line"
    expect(first_result[1][:class]).to include "blacklight-icons-stanford"
    expect(first_result[2][:class]).to include "blacklight-icons-restricted"
  end
end

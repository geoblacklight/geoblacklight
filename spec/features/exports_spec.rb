# frozen_string_literal: true

require "spec_helper"

feature "Export features" do
  feature "when esri web services are available" do
    feature "Open in ArcGIS Online" do
      scenario "shows up in tools" do
        visit solr_document_path "90f14ff4-1359-4beb-b931-5cb41d20ab90"
        expect(page).to have_css "li.arcgis a", text: "Open in ArcGIS Online"
      end
    end
  end
end

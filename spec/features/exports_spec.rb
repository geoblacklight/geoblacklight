require 'spec_helper'

feature 'Export features' do
  feature 'when item is public and wfs is available' do
    feature 'Open in Carto' do
      scenario 'shows up in tools' do
        visit solr_document_path 'tufts-cambridgegrid100-04'
        expect(page).to have_css 'li.carto a', text: 'Open in Carto'
        click_link 'Open in Carto'
      end
    end
  end
  feature 'when esri web services are available' do
    feature 'Open in ArcGIS Online' do
      scenario 'shows up in tools' do
        visit solr_document_path '90f14ff4-1359-4beb-b931-5cb41d20ab90'
        expect(page).to have_css 'li.arcgis a', text: 'Open in ArcGIS Online'
      end
    end
  end
  feature 'when restricted or no wfs' do
    scenario 'is not in tools' do
      visit solr_document_path 'princeton-02870w62c'
      expect(page).not_to have_css 'li.carto a', text: 'Open in Carto'
    end
  end
end

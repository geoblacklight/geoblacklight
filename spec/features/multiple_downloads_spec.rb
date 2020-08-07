require 'spec_helper'

feature 'Multiple downloads' do
  feature 'when item has multiple downloads in dct_references_s' do
    scenario 'downloads are listed in download card' do
      visit solr_document_path 'cugir-007950'
      within '.card.downloads' do
        expect(page).to have_link 'Shapefile', href: 'https://cugir-data.s3.amazonaws.com/00/79/50/cugir-007950.zip'
        expect(page).to have_link 'PDF', href: 'https://cugir-data.s3.amazonaws.com/00/79/50/agBROO.pdf'
        expect(page).to have_link 'KMZ', href: 'https://cugir-data.s3.amazonaws.com/00/79/50/agBROO2011.kmz'
      end
    end
  end
end

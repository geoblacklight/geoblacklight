require 'spec_helper'

feature 'Metadata tools' do
  feature 'when metadata references are available', js: :true do
    scenario 'shows up in tools' do
      visit solr_document_path 'stanford-cg357zz0321'
      expect(page).to have_css 'li.metadata a', text: 'Metadata'
      click_link 'Metadata'
      using_wait_time 15 do
        within '.metadata-view' do
          expect(page).to have_css '.pill-metadata', text: 'ISO 19139'
          expect(page).to have_css 'dt', text: 'Identification Information'
          expect(page).to have_css 'dt', text: 'Metadata Reference Information'
        end
      end
    end
  end
  feature 'when metadata references are not available' do
    scenario 'is not in tools' do
      visit solr_document_path 'mit-us-ma-e25zcta5dct-2000'
      expect(page).not_to have_css 'li.metadata a', text: 'Metadata'
    end
  end
end

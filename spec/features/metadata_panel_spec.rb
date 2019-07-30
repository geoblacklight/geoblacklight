require 'spec_helper'

feature 'Metadata tools' do
  feature 'when metadata references are available', js: :true do
    scenario 'shows up as HTML' do
      visit solr_document_path 'harvard-g7064-s2-1834-k3'
      expect(page).to have_css 'li.metadata a', text: 'Metadata'
      click_link 'Metadata'
      using_wait_time 15 do
        within '.metadata-view' do
          expect(page).to have_css '.pill-metadata', text: 'FGDC'
          expect(page).to have_css 'dt', text: 'Identification Information'
          expect(page).to have_css 'dt', text: 'Metadata Reference Information'
        end
      end
    end
    scenario 'shows up as XML' do
      visit solr_document_path 'stanford-fb897vt9938'
      expect(page).to have_css 'li.metadata a', text: 'Metadata'
      click_link 'Metadata'
      using_wait_time 15 do
        within '.metadata-view' do
          expect(page).to have_css '.pill-metadata', text: 'MODS'
          expect(page).to have_css '.CodeRay'
        end
      end
    end
  end
  feature 'when metadata references are not available' do
    scenario 'is not in tools' do
      visit solr_document_path 'mit-f6rqs4ucovjk2'
      expect(page).not_to have_css 'li.metadata a', text: 'Metadata'
    end
  end
end

require 'spec_helper'

feature 'Data dictionary download tool' do
  feature 'when data_dictionary reference present' do
    scenario 'shows up in tools' do
      visit solr_document_path 'nyu_2451_34502'
      expect(page).to have_css 'li.data_dictionary a', text: 'Documentation'
    end
  end
  feature 'when data_dictionary reference absent' do
    scenario 'download tool is not rendered' do
      visit solr_document_path 'stanford-cg357zz0321'
      expect(page).not_to have_css 'li.data_dictionary a', text: 'Documentation'
    end
  end
end

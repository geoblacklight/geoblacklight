# frozen_string_literal: true
require 'spec_helper'

feature 'Metadata display on show page' do
  scenario 'with default CatalogController specified fields' do
    visit solr_document_path 'stanford-dp018hs9766'
    within '.document-metadata' do
      expect(page).to have_css 'dt', count: 8
      expect(page).to have_css 'dd', count: 8
      expect(page).to have_css 'div.truncate-abstract', count: 1
    end
  end
end

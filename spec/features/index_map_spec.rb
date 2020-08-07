# frozen_string_literal: true
require 'spec_helper'

feature 'Index map' do
  # Colors
  default_color = '#1eb300'
  selected_color = '#006bde'
  scenario 'displays index map viewer (polygon)', js: true do
    visit solr_document_path('stanford-fb897vt9938')
    # Wait until SVG elements are added
    expect(page).to have_css '.leaflet-overlay-pane svg'
    within '#map' do
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
      find('svg g path:nth-child(2)').click
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{selected_color}']"
      first('svg g path').click
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
    end
  end
  scenario 'displays index map viewer (points)', js: true do
    visit solr_document_path('cornell-ny-aerial-photos-1960s')
    # Wait until SVG elements are added
    expect(page).to have_css '.leaflet-overlay-pane svg'
    within '#map' do
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
      find('svg g path:nth-child(2)').click
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{selected_color}']"
      first('svg g path').click
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
    end
  end
end

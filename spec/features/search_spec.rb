# frozen_string_literal: true
require 'spec_helper'

feature 'Search' do
  scenario 'Suppressed records are hidden' do
    visit '/?q=Sanborn+Map+Company'
    expect(page).to have_css '.document', count: 1
  end

  scenario 'When searching child records from a parent record, supressed records are not hidden', js: true do
    visit '/catalog/princeton-1r66j405w'

    within('.card.relations.relationship-source_descendants') do
      expect(page).to have_link(href: /f%5Bdct_source_sm%5D/)
    end

    click_link 'Browse all 4 records...'
    expect(page).to have_css '.document', count: 4
  end
end

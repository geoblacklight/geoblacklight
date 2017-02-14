require 'spec_helper'

feature 'Empty search' do
  before do
    visit root_path
  end
  scenario 'Entering empty search returns results page' do
    click_button 'search'
    expect(page).to have_css '#documents'
  end
end

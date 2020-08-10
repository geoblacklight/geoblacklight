# frozen_string_literal: true
require 'spec_helper'

feature 'Help Text' do
  scenario 'Displays help text entry' do
    visit '/catalog/stanford-cg357zz0321'
    expect(page).to have_css '.help-text', count: 1
  end
end

# frozen_string_literal: true
require 'spec_helper'

feature 'Suppressed records' do
  scenario 'are viewable' do
    visit solr_document_path 'princeton-jq085m62x'
    expect(page).to have_css('#document')
  end

  scenario 'are exportable' do
    visit solr_document_path 'princeton-jq085m62x'
    click_link 'Web services'
    expect(page).to have_css 'h1.modal-title', text: 'Web services'
  end
end

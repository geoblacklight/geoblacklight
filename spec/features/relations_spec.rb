# frozen_string_literal: true
require 'spec_helper'

feature 'Display related documents' do
  scenario 'Record with dc_source_sm value(s) should have parent(s)' do
    visit relations_solr_document_path('nyu_2451_34502')
    expect(page).to have_css('.relations .card-header h2', text: 'Source Datasets')
  end

  scenario 'Record that is pointed to by others should have children' do
    visit relations_solr_document_path('nyu_2451_34635')
    expect(page).to have_css('.relations .card-header h2', text: 'Derived Datasets')
  end

  scenario 'Relations should respond to json' do
    visit relations_solr_document_path('nyu_2451_34635', format: 'json')
    response = JSON.parse(page.body)
    expect(response['ancestors']['numFound']).to eq 0
    expect(response['descendants']['docs'].first['layer_slug_s']).to eq 'nyu_2451_34502'
    expect(response['current_doc']).to eq 'nyu_2451_34635'
  end

  scenario 'Record with relations should render widget in catalog#show', js: true do
    visit solr_document_path('nyu_2451_34635')
    expect(page).to have_css('.card.relations')
    expect(page).to have_css('div.card-header', text: 'Derived Datasets')
  end

  scenario 'Record without relations should not render widget in catalog#show', js: true do
    visit solr_document_path('harvard-g7064-s2-1834-k3')
    expect(page).to have_no_css('.card.relations')
  end
end

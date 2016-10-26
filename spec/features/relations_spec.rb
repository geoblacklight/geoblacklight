require 'spec_helper'

feature 'Display related documents' do
  let(:expected_json_resp) do
    {
      'ancestors' =>
        {
          'numFound' => 0,
          'start' => 0,
          'docs' => []
        },
      'descendants' =>
            {
              'numFound' => 1,
              'start' => 0,
              'docs' =>
                    [
                      {
                        'dc_title_s' => '2015 New York City Subway Complexes and Ridership',
                        'layer_slug_s' => 'nyu_2451_34502'
                      }
                    ]
            },
      'current_doc' => 'nyu_2451_34635'
    }
  end
  scenario 'Record with dc_source_sm value(s) should have parent(s)' do
    visit relations_solr_document_path('nyu_2451_34502')
    expect(page).to have_css('ul b', text: 'Source Datasets')
  end

  scenario 'Record that is pointed to by others should have children' do
    visit relations_solr_document_path('nyu_2451_34635')
    expect(page).to have_css('ul b', text: 'Derived Datasets')
  end

  scenario 'Relations should respond to json' do
    visit relations_solr_document_path('nyu_2451_34635', format: 'json')
    expect(page.body).to eq(expected_json_resp.to_json)
  end

  scenario 'Record with relations should render widget in catalog#show', js: true do
    visit solr_document_path('nyu_2451_34635')
    expect(page).to have_css('div.panel-heading', text: 'Data Relations')
  end

  scenario 'Record without relations should not render widget in catalog#show', js: true do
    visit solr_document_path('harvard-g7064-s2-1834-k3')
    expect(page).to have_no_css('div.panel-heading', text: 'Data Relations')
  end
end

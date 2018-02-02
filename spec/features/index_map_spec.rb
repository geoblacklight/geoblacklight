require 'spec_helper'

feature 'Index map' do
  scenario 'displays index map viewer (polygon)', js: true do
    visit solr_document_path('stanford-fb897vt9938')
    # Wait until SVG elements are added
    expect(page).to have_css '.leaflet-overlay-pane svg'
    page.first('svg g path').click
    within '.index-map-info' do
      expect(page).to have_css 'h3', text: 'Dabao Kinbōzu -- ダバオ近傍圖'
      expect(page).to have_css 'a img[src="https://stacks.stanford.edu/image/iiif/zh828kt2136%2Fzh828kt2136_00_0001/full/!400,400/0/default.jpg"]'
      within 'dl' do
        expect(page).to have_css 'dt', text: 'Website'
        expect(page).to have_css 'dd a', text: 'http://purl.stanford.edu/zh828kt2136'
        expect(page).to have_css 'dt', text: 'Download'
        expect(page).to have_css 'dd a', text: 'https://embed.stanford.edu/iframe?url=https://purl.stanford.edu/zh828kt2136&hide_title=true#'
        expect(page).to have_css 'dt', text: 'Record Identifier'
        expect(page).to have_css 'dd', text: '10532136'
        expect(page).to have_css 'dt', text: 'Label'
        expect(page).to have_css 'dd', text: 'SHEET 8'
      end
    end
  end
  scenario 'displays index map viewer (points)', js: true do
    visit solr_document_path('cornell-ny-aerial-photos-1960s')
    # Wait until SVG elements are added
    expect(page).to have_css '.leaflet-overlay-pane svg'
    page.first('svg g path').click
    within '.index-map-info' do
      expect(page).to have_css 'img[src="http://stor.artstor.org/stor/e6d1510d-de11-436a-9bfd-3dcdfbbc6296_size2"]'
      within 'dl' do
        expect(page).to have_css 'dt', text: 'Download'
        expect(page).to have_css 'dd a', text: 'http://stor.artstor.org/stor/e6d1510d-de11-436a-9bfd-3dcdfbbc6296.jpg'
        expect(page).to have_css 'dt', text: 'Record Identifier'
        expect(page).to have_css 'dd', text: 'ss:201109'
        expect(page).to have_css 'dt', text: 'Label'
        expect(page).to have_css 'dd', text: 'ARO-1DD-14'
      end
    end
  end
end

require 'spec_helper'

feature 'Download layer', js: true do
  scenario 'clicking shapefile download button should trigger download' do
    expect_any_instance_of(ShapefileDownload).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-shapefile.zip')
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('button', text: 'Download').click
    find('a', text: 'Shapefile').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-shapefile.zip is ready for download')
  end
  scenario 'clicking kmz download button should trigger download' do
    expect_any_instance_of(KmzDownload).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-kmz.kmz')
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('button', text: 'Download').click
    find('a', text: 'KMZ').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-kmz.kmz is ready for download')
  end
end

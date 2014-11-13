require 'spec_helper'

feature 'Download layer' do
  scenario 'clicking shapefile download button should trigger download', js: true do
    expect_any_instance_of(ShapefileDownload).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-shapefile.zip')
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('button', text: 'Download').click
    find('a', text: 'Shapefile').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-shapefile.zip is ready for download')
  end
  scenario 'clicking kmz download button should trigger download', js: true do
    expect_any_instance_of(KmzDownload).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-kmz.kmz')
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('button', text: 'Download').click
    find('a', text: 'KMZ').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-kmz.kmz is ready for download')
  end
  scenario 'restricted layer should not have download available to non logged in user' do
    visit catalog_path('stanford-jf841ys4828')
    expect(page).to have_css 'a', text: 'Login to view and download'
    expect(page).to_not have_css 'button', text: 'Download'
  end
  scenario 'restricted layer should have download available to logged in user' do
    sign_in
    visit catalog_path('stanford-jf841ys4828')
    expect(page).to_not have_css 'a', text: 'Login to view and download'
    expect(page).to have_css 'button', text: 'Download'
  end
end

require 'spec_helper'

feature 'Download layer' do
  let(:shapefile_download) { instance_double(Geoblacklight::ShapefileDownload) }
  let(:kmz_download) { instance_double(Geoblacklight::KmzDownload) }
  let(:hgl_download) { instance_double(Geoblacklight::HglDownload) }

  before do
    allow(Geoblacklight::ShapefileDownload).to receive(:new).and_return(shapefile_download)
    allow(Geoblacklight::KmzDownload).to receive(:new).and_return(kmz_download)
    allow(Geoblacklight::HglDownload).to receive(:new).and_return(hgl_download)
  end

  scenario 'clicking initial shapefile download button should trigger download', js: true do
    expect(shapefile_download).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-shapefile.zip')
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    find('a', text: 'Download Shapefile').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-shapefile.zip is ready for download')
  end
  scenario 'failed download should return message with link to layer', js: true do
    expect(shapefile_download).to receive(:get).and_raise(Geoblacklight::Exceptions::ExternalDownloadFailed.new(message: 'Failed', url: 'http://www.example.com/failed'))
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    find('a', text: 'Download Shapefile', match: :first).click
    expect(page).to have_css 'div.alert.alert-danger', text: 'Sorry, the requested file could not be downloaded, try downloading it directly from:'
    expect(page).to have_css 'a', text: 'http://www.example.com/failed'
  end
  scenario 'clicking kmz download button should trigger download', js: true do
    expect(kmz_download).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-kmz.kmz')
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    find('button.download-dropdown-toggle').click
    find('a', text: 'Download KMZ').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-kmz.kmz is ready for download')
  end
  scenario 'jpg download option should be present under toggle' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css('li a', text: 'Download JPG')
  end
  scenario 'clicking jpg download button should redirect to external image' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css("a.btn.btn-default[href='http://libimages.princeton.edu/loris2/pudl0076%2Fmap_pownall%2F00000001.jp2/full/full/0/default.jpg']", text: 'Download JPG')
  end
  scenario 'options should be available under toggle' do
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    find('button.download-dropdown-toggle').click
    expect(page).to have_css('li a', text: 'Download Shapefile')
    expect(page).to have_css('li a', text: 'Download KMZ')
  end
  scenario 'restricted layer should not have download available to non logged in user' do
    visit solr_document_path('stanford-cg357zz0321')
    expect(page).to have_css 'a', text: 'Login to view and download'
    expect(page).not_to have_css 'button', text: 'Download Shapefile'
  end
  scenario 'restricted layer should have download available to logged in user' do
    sign_in
    visit solr_document_path('stanford-cg357zz0321')
    expect(page).not_to have_css 'a', text: 'Login to view and download'
    expect(page).to have_css 'a', text: 'Download Shapefile'
    expect(page).to have_css 'button.download-dropdown-toggle'
  end
  scenario 'layer with direct download and wms/wfs should include all download types' do
    sign_in
    visit solr_document_path('stanford-cg357zz0321')
    expect(page).to have_css 'a', text: 'Download Shapefile'
    find('button.download-dropdown-toggle').click
    expect(page).to have_css 'li.dropdown-header', text: 'Original'
    expect(page).to have_css 'li.dropdown-header', text: 'Generated'
    expect(page).to have_css 'li a', text: 'Download Shapefile'
    expect(page).to have_css 'li a', text: 'Download KMZ'
  end
  scenario 'clicking GeoTIFF button for Harvard layer should show email form', js: true do
    visit solr_document_path('harvard-g7064-s2-1834-k3')
    find('a', text: 'Download GeoTIFF').click
    expect(page).to have_css('#hglRequest')
  end
  scenario 'submitting email form should trigger HGL request', js: true do
    expect(hgl_download).to receive(:get).and_return('success')
    visit solr_document_path('harvard-g7064-s2-1834-k3')
    find('a', text: 'Download GeoTIFF').click
    within '#hglRequest' do
      fill_in('Email', with: 'foo@example.com')
      click_button('Request')
    end
    expect(page).to have_content('You should receive an email when your download is ready')
  end
end

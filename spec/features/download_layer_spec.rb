# frozen_string_literal: true
require 'spec_helper'

feature 'Download layer' do
  let(:shapefile_download) { instance_double(Geoblacklight::ShapefileDownload) }
  let(:kmz_download) { instance_double(Geoblacklight::KmzDownload) }

  before do
    allow(Geoblacklight::ShapefileDownload).to receive(:new).and_return(shapefile_download)
    allow(Geoblacklight::KmzDownload).to receive(:new).and_return(kmz_download)
  end

  scenario 'clicking initial shapefile download button should trigger download', js: true do
    expect(shapefile_download).to receive(:get).and_return('mit-f6rqs4ucovjk2-shapefile.zip')
    visit solr_document_path('mit-f6rqs4ucovjk2')
    find('a[data-download-type="shapefile"]', text: 'Export').click
    expect(page).to have_css(
      'a[href="/download/file/mit-f6rqs4ucovjk2-shapefile.zip"]',
      text: 'Your file mit-f6rqs4ucovjk2-shapefile.zip is ready for download'
    )
  end
  scenario 'failed download should return message with link to layer', js: true do
    expect(shapefile_download).to receive(:get).and_raise(Geoblacklight::Exceptions::ExternalDownloadFailed.new(message: 'Failed', url: 'http://www.example.com/failed'))
    visit solr_document_path('mit-f6rqs4ucovjk2')
    find('a[data-download-type="shapefile"]', text: 'Export').click
    expect(page).to have_css 'div.alert.alert-danger', text: 'Sorry, the requested file could not be downloaded. Try downloading it directly from:'
    expect(page).to have_css 'a', text: 'http://www.example.com/failed'
  end
  scenario 'clicking kmz download button should trigger download', js: true do
    expect(kmz_download).to receive(:get).and_return('mit-f6rqs4ucovjk2-kmz.kmz')
    visit solr_document_path('mit-f6rqs4ucovjk2')
    find('a[data-download-type="kmz"]', text: 'Export').click
    expect(page).to have_css(
      'a[href="/download/file/mit-f6rqs4ucovjk2-kmz.kmz"]',
      text: 'Your file mit-f6rqs4ucovjk2-kmz.kmz is ready for download'
    )
  end
  scenario 'jpg download option should be present under toggle' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css('li a', text: 'Original JPG')
  end
  scenario 'clicking jpg download button should redirect to external image' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css("a.btn.btn-default[href='https://libimages.princeton.edu/loris/pudl0076/map_pownall/00000001.jp2/full/full/0/default.jpg']", text: 'Original JPG')
  end
  scenario 'options should be available under toggle' do
    visit solr_document_path('mit-f6rqs4ucovjk2')
    expect(page).to have_css('li a[data-download-type="shapefile"]', text: 'Export')
    expect(page).to have_css('li a[data-download-type="kmz"]', text: 'Export')
  end
  scenario 'restricted layer should not have download available to non logged in user' do
    visit solr_document_path('stanford-cg357zz0321')
    expect(page).to have_css 'a', text: 'Login to View and Download'
    expect(page).not_to have_css 'button', text: 'Download Shapefile'
  end
  scenario 'restricted layer should have download available to logged in user' do
    sign_in
    visit solr_document_path('stanford-cg357zz0321')
    expect(page).not_to have_css 'a', text: 'Login to view and download'
    expect(page).to have_css 'a[data-download-type="shapefile"]', text: 'Export'
  end
  scenario 'layer with direct download and wms/wfs should include all download types' do
    sign_in
    visit solr_document_path('stanford-cg357zz0321')
    expect(page).to have_css 'h2', text: 'Downloads'
    expect(page).to have_css 'a', text: 'Original Shapefile'
    expect(page).to have_css 'h2', text: 'Export Formats'
    expect(page).to have_css 'a', text: 'Export'
  end
  scenario 'clicking GeoTIFF button for Harvard layer should show email form', js: true do
    visit solr_document_path('harvard-g7064-s2-1834-k3')
    find('a[data-download-type="harvard-hgl"]', text: 'GeoTIFF').click
    expect(page).to have_css('#hglRequest')
  end
  context 'with a successful request to the server' do
    let(:hgl_download) { instance_double(Geoblacklight::HglDownload) }

    xscenario 'submitting email form should trigger HGL request', js: true do
      # There are currently difficulties with testing the HGL downloader
      visit solr_document_path('harvard-g7064-s2-1834-k3')
      find('a[data-download-type="harvard-hgl"]', text: 'Original GeoTIFF').click

      allow_any_instance_of(Geoblacklight::HglDownload).to receive(:new).and_return(hgl_download)
      allow(hgl_download).to receive(:get).and_return('success')

      within '#hglRequest' do
        fill_in('Email', with: 'foo@example.com')
        click_button('Request')
      end
      expect(page).to have_css('.alert-success')
      expect(page).to have_content('You should receive an email when your download is ready')
    end
  end
end

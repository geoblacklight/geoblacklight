# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Download layer" do
  let(:shapefile_download) { instance_double(Geoblacklight::ShapefileDownload) }
  let(:kmz_download) { instance_double(Geoblacklight::KmzDownload) }
  let(:csv_download) { instance_double(Geoblacklight::CsvDownload) }

  before do
    allow(Geoblacklight::ShapefileDownload).to receive(:new).and_return(shapefile_download)
    allow(Geoblacklight::KmzDownload).to receive(:new).and_return(kmz_download)
    allow(Geoblacklight::CsvDownload).to receive(:new).and_return(csv_download)
  end

  # cleanup any downloaded files
  after do
    FileUtils.rm("tufts-cambridgegrid100-04-shapefile.zip", force: true)
    FileUtils.rm("tufts-cambridgegrid100-04-kmz.kmz", force: true)
  end

  scenario "clicking initial shapefile download button should trigger download", js: true do
    allow(shapefile_download).to receive(:get).and_return("tufts-cambridgegrid100-04-shapefile.zip")
    visit solr_document_path("tufts-cambridgegrid100-04")
    find("#downloads-button").click
    find('a[data-download-type="shapefile"]', text: "Export Shapefile").click
    expect(page).to have_css(
      'a[href="/download/file/tufts-cambridgegrid100-04-shapefile.zip"]',
      text: "Your file tufts-cambridgegrid100-04-shapefile.zip is ready for download"
    )
  end

  scenario "failed download should return message with link to layer", js: true do
    allow(shapefile_download).to receive(:get).and_raise(Geoblacklight::Exceptions::ExternalDownloadFailed.new(
      message: "Failed", url: "http://www.example.com/failed"
    ))
    visit solr_document_path("mit-f6rqs4ucovjk2")
    find("#downloads-button").click
    find('#downloads-collapse a[data-download-type="shapefile"]', text: "Export Shapefile").click
    expect(page).to have_text "Download failed (shapefile)"
    expect(page).to have_css "div.alert.alert-danger", text: "Sorry, the requested file could not be downloaded."
  end

  scenario "clicking kmz download button should trigger download", js: true do
    allow(kmz_download).to receive(:get).and_return("tufts-cambridgegrid100-04-kmz.kmz")
    visit solr_document_path("tufts-cambridgegrid100-04")
    find("#downloads-button").click
    find('#downloads-collapse a[data-download-type="kmz"]', text: "Export KMZ").click
    expect(page).to have_css(
      'a[href="/download/file/tufts-cambridgegrid100-04-kmz.kmz"]',
      text: "Your file tufts-cambridgegrid100-04-kmz.kmz is ready for download"
    )
  end

  scenario "jpg download option should be present under toggle" do
    visit solr_document_path("princeton-02870w62c")
    find("#downloads-button").click
    expect(page).to have_css("#downloads-collapse a", text: "Original JPG")
  end

  scenario "clicking jpg download button should redirect to external image" do
    visit solr_document_path("princeton-02870w62c")
    find("#downloads-button").click
    expect(page).to have_css(
      "#downloads-collapse a[href='https://iiif-cloud.princeton.edu/iiif/2/6c%2F52%2F12%2F6c5212e81bc845f59bb1cdc740a88bad%2Fintermediate_file/full/full/0/default.jpg']", text: "Original JPG"
    )
  end

  scenario "options should be available under toggle" do
    visit solr_document_path("tufts-cambridgegrid100-04")
    find("#downloads-button").click
    expect(page).to have_css('#downloads-collapse a[data-download-type="shapefile"]', text: "Export Shapefile")
    expect(page).to have_css('#downloads-collapse a[data-download-type="kmz"]', text: "Export KMZ")
  end

  scenario "restricted layer should not have download available to non logged in user" do
    visit solr_document_path("stanford-cg357zz0321")
    expect(page).to have_css "a", text: "Login to View and Download"
    expect(page).not_to have_css "button", text: "Download"
  end

  scenario "restricted layer should have download available to logged in user" do
    sign_in
    visit solr_document_path("stanford-cg357zz0321")
    expect(page).not_to have_css "a", text: "Login to view and download"
    expect(page).to have_css "button", text: "Download"
  end

  scenario "layer with direct download and wms/wfs should include all download types" do
    sign_in
    visit solr_document_path("stanford-cg357zz0321")
    find("#downloads-button").click
    expect(page).to have_css("#downloads-collapse a", text: "Original")
    expect(page).to have_css("#downloads-collapse a", text: "Export")
  end
end

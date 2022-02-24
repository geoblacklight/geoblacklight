# frozen_string_literal: true
require 'spec_helper'

feature 'Download display on show page' do
  scenario 'with download String' do
    visit solr_document_path '2eddde2f-c222-41ca-bd07-2fd74a21f4de'
    find('#downloads-button').click
    within '#downloads-collapse' do
      expect(page).to have_selector(:css, 'a[href="ftp://gdrs.dnr.state.mn.us/gdrs/data/pub/us_mn_state_dnr/fgdb_base_usgs_scanned_topo_100k_drg.zip"]')
    end
  end

  scenario 'with download Array' do
    visit solr_document_path 'princeton-sx61dn82p'
    find('#downloads-button').click
    within '#downloads-collapse' do
      expect(page).to have_selector(:css, 'a[href="https://figgy.princeton.edu/downloads/a990e1b4-7f0e-44b8-ae2a-de7e93cdd74a/file/36a2274c-e0c6-4901-a14f-7c422d15e194"]')
      expect(page).to have_selector(:css, 'a[href="https://libimages1.princeton.edu/loris/figgy_prod/2e%2Fa9%2F43%2F2ea943b0bd4348fc9954b299f1b359f6%2Fintermediate_file.jp2/full/full/0/default.jpg"]')
    end
  end

  scenario 'with Harvard hgl_download' do
    visit solr_document_path 'harvard-g7064-s2-1834-k3'
    find('#downloads-button').click
    within '#downloads-collapse' do
      expect(page).to have_selector(:css, 'a[href="/download/hgl/harvard-g7064-s2-1834-k3"][data-download-type="harvard-hgl"]')
    end
  end
end

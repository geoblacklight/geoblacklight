# frozen_string_literal: true

require "spec_helper"

feature "Download display on show page" do
  scenario "with download String" do
    visit solr_document_path "2eddde2f-c222-41ca-bd07-2fd74a21f4de"
    find("#downloads-button").click
    within "#downloads-collapse" do
      expect(page).to have_selector(:css, 'a[href="ftp://gdrs.dnr.state.mn.us/gdrs/data/pub/us_mn_state_dnr/fgdb_base_usgs_scanned_topo_100k_drg.zip"]')
    end
  end

  scenario "with download Array" do
    visit solr_document_path "princeton-sx61dn82p"
    find("#downloads-button").click
    within "#downloads-collapse" do
      expect(page).to have_selector(:css, 'a[href="http://127.0.0.1:9002/data/princeton-sx61dn82p/princeton-sx61dn82p.tif"]')
      expect(page).to have_selector(:css, 'a[href="http://127.0.0.1:9001/iiif/data/princeton-sx61dn82p/princeton-sx61dn82p.tif/full/full/0/default.jpg"]')
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

feature 'Metadata tools' do
  feature 'when metadata references are available', js: :true do
    let(:iso19139) { File.read(Rails.root.join('..', 'spec', 'fixtures', 'iso19139', 'stanford-cg357zz0321.xml')) }
    let(:fgdc) { File.read(Rails.root.join('..', 'spec', 'fixtures', 'fgdc', 'harvard-g7064-s2-1834-k3.xml')) }
    let(:mods) { File.read(Rails.root.join('..', 'spec', 'fixtures', 'mods', 'stanford-cg357zz0321.mods')) }
    let(:fgdc_response) { instance_double(Faraday::Response) }
    let(:fgdc_connection) { instance_double(Faraday::Connection) }
    let(:iso19139_response) { instance_double(Faraday::Response) }
    let(:iso19139_connection) { instance_double(Faraday::Connection) }
    let(:response) { instance_double(Faraday::Response) }
    let(:connection) { instance_double(Faraday::Connection) }

    before do
      allow(iso19139_response).to receive(:body).and_return(iso19139)
      allow(iso19139_response).to receive(:status).and_return(200)
      allow(iso19139_connection).to receive(:get).and_return(iso19139_response)
      allow(Faraday).to receive(:new).with(url: 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.stanford.purl/master/cg/357/zz/0321/iso19139.xml').and_return(iso19139_connection)

      allow(fgdc_response).to receive(:body).and_return(fgdc)
      allow(fgdc_response).to receive(:status).and_return(200)
      allow(fgdc_connection).to receive(:get).and_return(fgdc_response)
      allow(Faraday).to receive(:new).with(url: 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.harvard/master/217/121/227/77/fgdc.xml').and_return(fgdc_connection)

      allow(response).to receive(:body).and_return(mods)
      allow(response).to receive(:status).and_return(200)
      allow(connection).to receive(:get).and_return(response)
      allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)

      allow(Faraday).to receive(:new).with(hash_including(url: 'http://127.0.0.1:8983/solr/blacklight-core/')).and_call_original
    end

    scenario 'shows up as HTML' do
      visit solr_document_path 'harvard-g7064-s2-1834-k3'
      expect(page).to have_css 'li.metadata a', text: 'Metadata'
      click_link 'Metadata'
      using_wait_time 15 do
        within '.metadata-view' do
          expect(page).to have_css '.pill-metadata', text: 'FGDC'
          expect(page).to have_css 'dt', text: 'Identification Information'
          expect(page).to have_css 'dt', text: 'Metadata Reference Information'
        end
      end
    end
    context 'when the metadata is in the XML' do
      let(:mods) { File.read(Rails.root.join('..', 'spec', 'fixtures', 'mods', 'fb897vt9938.mods')) }
      let(:response) { instance_double(Faraday::Response) }
      let(:connection) { instance_double(Faraday::Connection) }

      before do
        allow(response).to receive(:body).and_return(mods)
        allow(response).to receive(:status).and_return(200)
        allow(connection).to receive(:get).and_return(response)
        allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/fb897vt9938.mods').and_return(connection)
        allow(Faraday).to receive(:new).and_call_original
      end

      scenario 'shows up as XML' do
        visit solr_document_path 'stanford-cg357zz0321'
        expect(page).to have_css 'li.metadata a', text: 'Metadata'
        click_link 'Metadata'
        using_wait_time 15 do
          within '.metadata-view' do
            expect(page).to have_css '.pill-metadata', text: 'MODS'
            expect(page).to have_css '.CodeRay'
          end
        end
      end
    end
  end
  feature 'when metadata references are not available' do
    scenario 'is not in tools' do
      visit solr_document_path 'mit-f6rqs4ucovjk2'
      expect(page).not_to have_css 'li.metadata a', text: 'Metadata'
    end
  end
end

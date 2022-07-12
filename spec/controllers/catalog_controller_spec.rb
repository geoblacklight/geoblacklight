# frozen_string_literal: true
require 'spec_helper'

describe CatalogController, type: :controller do
  describe '#web_services' do
    it 'returns a document based off an id' do
      get :web_services, params: { id: 'mit-f6rqs4ucovjk2' }
      expect(response).to have_http_status :ok
      expect(assigns(:documents)).not_to be_nil
    end
  end

  describe '.default_solr_params' do
    it 'sets the number of rows returned by Solr to 10 and does not filter the results' do
      get :index
      expect(response).to have_http_status :ok
      expect(assigns(:response).docs).not_to be_empty
      expect(assigns(:response).docs.length).to eq 10
    end

    it 'sets the starting document index to 0' do
      get :index
      expect(response).to have_http_status :ok
      expect(assigns(:response).docs).not_to be_empty
      expect(assigns(:response).docs.first.id).to eq 'stanford-cg357zz0321'
    end

    context 'with altered default parameters' do
      let(:blacklight_config) { Blacklight::Configuration.new }

      before do
        allow(controller).to receive_messages blacklight_config: blacklight_config
      end

      it 'sets the starting document index' do
        blacklight_config.default_solr_params = { start: 2, 'q.alt' => '*:*' }
        get :index
        expect(response).to have_http_status :ok
        expect(assigns(:response).docs).not_to be_empty
        expect(assigns(:response).docs.first.id).to eq 'mit-001145244'
      end

      it 'filters using a default DisMax query when no query is provided by the client' do
        blacklight_config.default_solr_params = { start: 10, 'q.alt' => '{!dismax}id:nyu' }
        get :index
        expect(response).to have_http_status :ok
        expect(assigns(:response).docs).to be_empty
      end
    end

    context 'with altered per page parameters' do
      let(:blacklight_config) { Blacklight::Configuration.new }

      before do
        allow(controller).to receive_messages blacklight_config: blacklight_config
      end

      it 'alters the number of documents returned from Solr' do
        blacklight_config.default_per_page = 20
        get :index
        expect(response).to have_http_status :ok
        expect(assigns(:response).docs).not_to be_empty
        expect(assigns(:response).docs.length).to eq 20
      end
    end
  end

  describe '#raw' do
    it 'returns a JSON representation of a Solr Document' do
      get :raw, params: { id: 'tufts-cambridgegrid100-04' }
      expect(response).to have_http_status :ok
      expect(response.body).not_to be_empty
      response_values = JSON.parse(response.body)
      expect(response_values).to include 'gbl_mdVersion_s' => 'Aardvark'
      expect(response_values).to include Settings.FIELDS.TITLE => '100 Foot Grid Cambridge MA 2004'
      expect(response_values).to include Settings.FIELDS.IDENTIFIER => ['urn:geodata.tufts.edu:Tufts.CambridgeGrid100_04']
      expect(response_values).to include Settings.FIELDS.ACCESS_RIGHTS => 'Public'
      expect(response_values).to include Settings.FIELDS.PROVIDER => 'Tufts'
      expect(response_values).to include Settings.FIELDS.ID => 'tufts-cambridgegrid100-04'
      expect(response_values).to include Settings.FIELDS.GEOMETRY => 'ENVELOPE(-71.163984,-71.052581,42.408316,42.34757)'
    end
  end
end

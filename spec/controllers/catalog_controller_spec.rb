# frozen_string_literal: true

require "spec_helper"

RSpec.describe CatalogController, type: :controller do
  describe ".blacklight_config" do
    it "uses the metadata description component for the description field" do
      description_field = described_class.blacklight_config.show_fields[Geoblacklight.configuration.fields.description]

      expect(description_field.component).to eq Geoblacklight::MetadataDescriptionMarkdownComponent
    end
  end

  describe "#web_services" do
    it "returns a document based off an id" do
      get :web_services, params: {id: "berkeley-s7pq31"}
      expect(response).to have_http_status :ok
      expect(assigns(:documents)).not_to be_nil
    end
  end

  describe "#raw" do
    it "returns a JSON representation of a Solr Document" do
      get :raw, params: {id: "berkeley-s7st30"}
      expect(response).to have_http_status :ok
      expect(response.body).not_to be_empty
      response_values = JSON.parse(response.body)
      expect(response_values).to include "gbl_mdVersion_s" => "Aardvark"
      expect(response_values).to include Geoblacklight.configuration.fields.title => "2000 Census Block Groups, Calaveras County, California, 2018"
      expect(response_values).to include Geoblacklight.configuration.fields.identifier => ["https://geodata.lib.berkeley.edu/catalog/berkeley-s7st30"]
      expect(response_values).to include Geoblacklight.configuration.fields.access_rights => "Public"
      expect(response_values).to include Geoblacklight.configuration.fields.provider => "University of California Berkeley"
      expect(response_values).to include Geoblacklight.configuration.fields.id => "berkeley-s7st30"
      expect(response_values).to include Geoblacklight.configuration.fields.geometry => "ENVELOPE(-120.99553605196368,-120.01994492166297,38.50999518077548,37.83228807647538)"
    end
  end
end

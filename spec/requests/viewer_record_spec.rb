# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Viewer record", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:references) { JSON.parse(response.parsed_body[Geoblacklight.configuration.fields.references]) }

  # Restricted, and provided by this app's own institution, so signing in makes the difference
  let(:restricted) { "stanford-dp018hs9766" }

  it "withholds a restricted record's data from a reader who isn't signed in" do
    get viewer_solr_document_path(restricted)

    expect(response).to have_http_status(:ok)
    expect(references.keys).not_to include("https://github.com/cogeotiff/cog-spec", "http://schema.org/downloadUrl")
    expect(references.keys).to include("http://www.isotc211.org/schemas/2005/gmd/")
  end

  it "hands over the same record once that reader signs in" do
    sign_in FactoryBot.create(:user)
    get viewer_solr_document_path(restricted)

    expect(references.keys).to include("https://github.com/cogeotiff/cog-spec", "http://schema.org/downloadUrl")
  end

  it "hands over a public record in full" do
    get viewer_solr_document_path("berkeley-s7pq31")

    expect(references.keys).to include("http://www.opengis.net/def/serviceType/ogc/wms")
  end

  it "reports a record that isn't there as missing" do
    get viewer_solr_document_path("no-such-record")

    expect(response).to have_http_status(:not_found)
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Viewer requests", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:origins) { ["https://stacks.stanford.edu/"] }

  # Restricted, and provided by this app's own institution, so signing in makes the difference
  let(:restricted) { "stanford-dp018hs9766" }

  around do |example|
    configured = Geoblacklight.configuration.restricted_origins
    Geoblacklight.configuration.restricted_origins = origins
    example.run
    Geoblacklight.configuration.restricted_origins = configured
  end

  def restricted_origins
    Capybara.string(response.body).find("ogm-viewer")["data-restricted-origins"]
  end

  it "names the services a signed-in reader's requests need to carry cookies to" do
    sign_in FactoryBot.create(:user)
    get solr_document_path(restricted)

    expect(JSON.parse(restricted_origins)).to eq origins
  end

  it "names none for a reader who isn't signed in" do
    get solr_document_path(restricted)

    expect(restricted_origins).to be_nil
  end

  it "names none for a public record, which has nothing that needs authorizing" do
    sign_in FactoryBot.create(:user)
    get solr_document_path("berkeley-s7pq31")

    expect(restricted_origins).to be_nil
  end

  context "when no services are configured" do
    let(:origins) { [] }

    it "names none" do
      sign_in FactoryBot.create(:user)
      get solr_document_path(restricted)

      expect(restricted_origins).to be_nil
    end
  end
end

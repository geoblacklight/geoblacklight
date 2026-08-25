# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Viewer requests", js: true do
  # What the viewer would ask about while previewing this record: the restricted file itself, and
  # the basemap it draws underneath, which is an unrelated origin
  let(:probe) do
    <<~JS
      (() => {
        const viewer = document.querySelector("ogm-viewer")
        if (typeof viewer.requestTransform !== "function") return null
        return {
          service: viewer.requestTransform("https://stacks.stanford.edu/file/druid:dp018hs9766/es2005_1m_10color_cog.tif", "tile"),
          basemap: viewer.requestTransform("https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json", "metadata"),
        }
      })()
    JS
  end

  around do |example|
    configured = Geoblacklight.configuration.restricted_origins
    Geoblacklight.configuration.restricted_origins = ["https://stacks.stanford.edu/"]
    example.run
    Geoblacklight.configuration.restricted_origins = configured
  end

  scenario "a signed-in reader's requests carry cookies to the configured service, and nowhere else" do
    sign_in
    visit solr_document_path("stanford-dp018hs9766")

    # The transform is set once the initializers run, which is a moment after the page arrives
    transform = page.document.synchronize(5) do
      page.evaluate_script(probe) || raise(Capybara::ElementNotFound)
    end

    expect(transform["service"]).to eq("credentials" => "include")
    expect(transform["basemap"]).to be_nil
  end
end

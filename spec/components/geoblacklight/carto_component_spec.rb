# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::CartoComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document: document))
  end
  let(:document) { instance_double(SolrDocument, id: 123, carto_reference: "http://demo.org/wfs/layer.json") }

  it "shows carto link" do
    expect(rendered).to have_text("Open in Carto")
    expect(rendered).to have_selector(:css, "a[href='http://oneclick.carto.com/?file=http%3A%2F%2Fdemo.org%2Fwfs%2Flayer.json&provider=GeoBlacklight&logo=http%3A%2F%2Fgeoblacklight.org%2Fimages%2Fgeoblacklight-logo.png']")
  end
end

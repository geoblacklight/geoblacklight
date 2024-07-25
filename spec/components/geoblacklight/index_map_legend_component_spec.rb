# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::IndexMapLegendComponent, type: :component do
  let(:document) { instance_double(SolrDocument) }

  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document:))
  end

  it "shows available map text" do
    expect(rendered).to have_text("Green tile indicates")
    expect(rendered).to have_selector(:css, ".index-map-legend-default")
  end

  it "shows unavailable map text" do
    expect(rendered).to have_text("Yellow tile indicates")
    expect(rendered).to have_selector(:css, ".index-map-legend-unavailable")
  end

  it "shows selected map text" do
    expect(rendered).to have_text("Blue tile indicates")
    expect(rendered).to have_selector(:css, ".index-map-legend-selected")
  end
end

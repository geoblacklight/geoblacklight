# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Geoblacklight::HomepageMapComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new)
  end

  it 'renders the map' do
    expect(rendered).to have_selector 'div#map'
    expect(rendered).to have_selector 'h3'
  end
end

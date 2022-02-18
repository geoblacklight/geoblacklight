# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Geoblacklight::IconFacetItemComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(suppress_link: true, **kwargs))
  end

  let(:kwargs) { { facet_item: facet_item } }
  let(:facet_item) { instance_double(Blacklight::FacetItemPresenter, label: 'Stanford', value: 'stanford', hits: 5, href: nil, selected?: false, facet_config: facet_config) }
  let(:facet_config) { Blacklight::Configuration::FacetField.new(field: 'provider_facet', label: 'Provider') }

  it 'prepends the icon to the facet item label' do
    expect(rendered).to have_selector('span.facet-label', text: 'Stanford')
    expect(rendered).to have_selector('span.facet-label svg title', text: 'Stanford University')
  end
end

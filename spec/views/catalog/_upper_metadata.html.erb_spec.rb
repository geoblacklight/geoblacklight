require 'spec_helper'

describe 'catalog/_upper_metadata.html.erb', type: :view do
  let(:document) { instance_double(SolrDocument) }
  let(:presenter) { instance_double(Blacklight::ShowPresenter) }
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_show_field Settings.FIELDS.CREATOR, label: 'Author(s)', itemprop: 'author'
      config.add_show_field Settings.FIELDS.DESCRIPTION, label: 'Description', itemprop: 'description', helper_method: :render_value_as_truncate_abstract
      config.add_show_field Settings.FIELDS.PUBLISHER, label: 'Publisher', itemprop: 'publisher'
      config.add_show_field Settings.FIELDS.PART_OF, label: 'Collection', itemprop: 'isPartOf'
      config.add_show_field Settings.FIELDS.SPATIAL_COVERAGE, label: 'Place(s)', itemprop: 'spatial', link_to_facet: true
      config.add_show_field Settings.FIELDS.SUBJECT, label: 'Subject(s)', itemprop: 'keywords', link_to_facet: true
      config.add_show_field Settings.FIELDS.TEMPORAL, label: 'Year', itemprop: 'temporal'
      config.add_show_field Settings.FIELDS.PROVENANCE, label: 'Held by', link_to_facet: true
    end
  end

  before do
    allow(document).to receive(:references)

    assign(:document, document)
    allow(presenter).to receive(:field_value)
    allow(view).to receive(:show_presenter).and_return(presenter)
    # https://github.com/projectblacklight/blacklight/blob/v7.0.0.rc1/app/helpers/blacklight/configuration_helper_behavior.rb#L31
    allow(view).to receive(:document_show_fields).and_return(blacklight_config.show_fields)
    allow(view).to receive(:should_render_show_field?).and_return(true)
  end

  it 'renders the field values for the default GeoBlacklight show fields' do
    expect(presenter).to receive(:field_value).with('dc_creator_sm')
    expect(presenter).to receive(:field_value).with('dc_description_s')
    expect(presenter).to receive(:field_value).with('dc_publisher_s')
    expect(presenter).to receive(:field_value).with('dct_isPartOf_sm')
    expect(presenter).to receive(:field_value).with('dct_spatial_sm')
    expect(presenter).to receive(:field_value).with('dc_subject_sm')
    expect(presenter).to receive(:field_value).with('dct_temporal_sm')
    expect(presenter).to receive(:field_value).with('dct_provenance_s')
    render
  end
end

require 'spec_helper'

describe GeoblacklightHelper, type: :helper do
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  describe '#render_facet_links' do
    let(:subject_field) { Settings.FIELDS.SUBJECT }
    it 'contains unique links' do
      expect(self).to receive(:search_catalog_path).exactly(3).times.and_return("http://example.com/catalog?f[#{subject_field}][]=category")
      html = Capybara.string(render_facet_links(subject_field, %w(Test Test Earth Science)))
      expect(html).to have_css 'a', count: 3
      expect(html).to have_css 'a', text: 'Test', count: 1
      expect(html).to have_css 'a', text: 'Earth', count: 1
      expect(html).to have_css 'a', text: 'Science', count: 1
    end
  end

  describe '#geoblacklight_icon' do
    it 'replaces special characters, lowercases, and subs spaces for hyphens' do
      html = Capybara.string(geoblacklight_icon('TEst & 123'))
      expect(html).to have_css '.geoblacklight-test-123'
    end
    it 'supports in use cases' do
      {
        'Paper map' => 'paper-map',
        'Michigan State' => 'michigan-state',
        'CD ROM' => 'cd-rom',
        'Lewis & Clark' => 'lewis-clark'
      }.each do |key, value|
        html = Capybara.string(geoblacklight_icon(key))
        expect(html).to have_css ".geoblacklight-#{value}"
      end
    end
  end

  describe '#proper_case_format' do
    it 'returns a properly cased format' do
      expect(proper_case_format('GEOJSON')).to eq 'GeoJSON'
    end
  end

  describe '#download_text' do
    it 'returns download text concatenated with proper case format' do
      expect(download_text('GEOJSON')).to eq 'Download GeoJSON'
    end
  end

  describe '#geoblacklight_basemap' do
    let(:blacklight_config) { double }
    it 'without configuration' do
      expect(blacklight_config).to receive(:basemap_provider).and_return(nil)
      expect(geoblacklight_basemap).to eq 'positron'
    end
    it 'with custom configuration' do
      expect(blacklight_config).to receive(:basemap_provider).and_return('positron')
      expect(geoblacklight_basemap).to eq 'positron'
    end
  end

  describe '#iiif_jpg_url' do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    let(:document_attributes) do
      {
        references_field => {
          'http://iiif.io/api/image' => 'https://example.edu/image/info.json'
        }.to_json
      }
    end

    it 'returns JPG download URL when given URL to a IIIF info.json' do
      assign(:document, document)
      expect(helper.iiif_jpg_url).to eq 'https://example.edu/image/full/full/0/default.jpg'
    end
  end

  describe '#snippit' do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    context 'as a String' do
      let(:document_attributes) do
        {
          value: 'This is a really long string that should get truncated when it gets rendered'\
          'in the index view to give a brief description of the contents of a particular document'\
          'indexed into Solr'
        }
      end
      it 'truncates longer strings to 150 characters' do
        expect(helper.snippit(document).length).to eq 150
      end
      it 'truncated string ends with ...' do
        expect(helper.snippit(document)[-3..-1]).to eq '...'
      end
    end
    context 'as an Array' do
      let(:document_attributes) do
        {
          value: ['This is a really long string that should get truncated when it gets rendered'\
          'in the index view to give a brief description of the contents of a particular document'\
          'indexed into Solr']
        }
      end
      it 'truncates longer strings to 150 characters' do
        expect(helper.snippit(document).length).to eq 150
      end
      it 'truncated string ends with ...' do
        expect(helper.snippit(document)[-3..-1]).to eq '...'
      end
    end
    context 'as a multivalued Array' do
      let(:document_attributes) do
        {
          value: %w(short description)
        }
      end
      it 'uses both values' do
        expect(helper.snippit(document)).to eq 'short description'
      end
      it 'does not truncate' do
        expect(helper.snippit(document)[-3..-1]).not_to eq '...'
      end
    end
  end

  describe '#render_web_services' do
    let(:reference) { double(type: 'wms') }
    it 'with a reference to a defined partial' do
      expect(helper).to receive(:render)
        .with(partial: 'web_services_wms', locals: { reference: reference })
      helper.render_web_services(reference)
    end
    it 'with a reference to a missing partial' do
      reference = double(type: 'iiif')
      # expect(helper).to receive(:render).and_raise ActionView::MissingTemplate
      expect(helper).to receive(:render)
        .with(partial: 'web_services_iiif', locals: { reference: reference })
        .and_raise ActionView::MissingTemplate.new({}, '', '', '', '')
      expect(helper).to receive(:render)
        .with(partial: 'web_services_default', locals: { reference: reference })
      helper.render_web_services(reference)
    end
  end

  describe '#leaflet_options' do
    it 'returns a hash of options for leaflet' do
      expect(leaflet_options[:VIEWERS][:WMS][:CONTROLS]).to eq(['Opacity'])
    end
  end

  describe '#render_value_as_truncate_abstract' do
    context 'with multiple values' do
      let(:document) { SolrDocument.new(value: %w(short description)) }
      it 'wraps in correct DIV class' do
        expect(helper.render_value_as_truncate_abstract(document)).to eq '<div class="truncate-abstract">short description</div>'
      end
    end
  end
end

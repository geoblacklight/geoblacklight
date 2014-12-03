require 'spec_helper'

describe GeoblacklightHelper do
  include GeoblacklightHelper
  include ActionView::Helpers::UrlHelper
  describe '#render_facet_links' do
    it 'should contain unique links' do
      expect(self).to receive(:catalog_index_path).exactly(3).times.and_return("http://example.com/catalog?f[dc_subject_sm][]=category")
      html = Capybara.string(render_facet_links('dc_subject_sm', ['Test', 'Test', 'Earth', 'Science']))
      expect(html).to have_css 'a', count: 3
      expect(html).to have_css 'a', text: 'Test', count: 1
      expect(html).to have_css 'a', text: 'Earth', count: 1
      expect(html).to have_css 'a', text: 'Science', count: 1
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

describe 'Catalog Routes', type: :routing do
  # Test paths for custom routes
  it "maps { :controller => 'catalog', :action => 'opensearch', :format => 'xml' } to /catalog/opensearch.xml" do
    expect(get: '/catalog/opensearch.xml').to route_to(controller: 'catalog', action: 'opensearch', format: 'xml')
  end
end

# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::SpatialSearchBehavior do
  subject { search_builder.with(user_params) }

  let(:user_params) { {} }
  let(:solr_params) { {} }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder).tap do |klass|
      include Blacklight::Solr::SearchBuilderBehavior
      klass.include(described_class)
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  describe '#hide_suppressed_records' do
    skip
  end
end

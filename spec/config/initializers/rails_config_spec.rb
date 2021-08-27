# frozen_string_literal: true
require 'spec_helper'

describe 'Config' do
  it 'Loads new v3.3 Settings.FIELDS defaults' do
    expect(Settings.FIELDS.IDENTIFIER).to eq 'dct_identifier_sm'
    expect(Settings.FIELDS.LANGUAGE).to eq 'dct_language_sm'
    expect(Settings.FIELDS.LAYER_MODIFIED).to eq 'gbl_mdModified_dt'
    expect(Settings.FIELDS.SOURCE).to eq 'dct_source_sm'
    expect(Settings.FIELDS.SUPPRESSED).to eq 'gbl_suppressed_b'
    expect(Settings.FIELDS.TYPE).to eq 'dc_type_s'
    expect(Settings.FIELDS.UNIQUE_KEY).to eq 'id'
  end

  it 'Loads new Aardvark relationships' do
    expect(Settings).to respond_to('RELATIONSHIPS_SHOWN')
    [:field, :query_type, :icon, :label].each do |method|
      expect(Settings.RELATIONSHIPS_SHOWN.MEMBER_OF).to respond_to(method)
    end
  end
end

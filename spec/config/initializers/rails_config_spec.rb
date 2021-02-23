# frozen_string_literal: true
require 'spec_helper'

describe 'Config' do
  it 'Loads new v3.3 Settings.FIELDS defaults' do
    expect(Settings.FIELDS.IDENTIFIER).to eq 'dc_identifier_s'
    expect(Settings.FIELDS.LANGUAGE).to eq 'dc_language_s'
    expect(Settings.FIELDS.LAYER_MODIFIED).to eq 'layer_modified_dt'
    expect(Settings.FIELDS.SOURCE).to eq 'dc_source_sm'
    expect(Settings.FIELDS.SUPPRESSED).to eq 'suppressed_b'
    expect(Settings.FIELDS.TYPE).to eq 'dc_type_s'
    expect(Settings.FIELDS.UNIQUE_KEY).to eq 'layer_slug_s'
  end
end

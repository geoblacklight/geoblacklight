# frozen_string_literal: true
require 'spec_helper'

describe 'Config' do
  it 'Loads new Aardvark relationships' do
    expect(Settings).to respond_to('RELATIONSHIPS_SHOWN')
    [:field, :query_type, :icon, :label].each do |method|
      expect(Settings.RELATIONSHIPS_SHOWN.MEMBER_OF).to respond_to(method)
    end
  end
end

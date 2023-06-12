# frozen_string_literal: true

require "spec_helper"

describe "Config" do
  it "Loads new v4.1 Settings defaults" do
    expect(Settings.FIELDS.DISPLAY_NOTE).to respond_to(:field)
    expect(Settings.DISPLAY_NOTES_SHOWN).to respond_to(:danger)
    expect(Settings.SIDEBAR_STATIC_MAP).to respond_to(:iiif)

    expect(Settings).to respond_to("RELATIONSHIPS_SHOWN")
    [:field, :query_type, :icon, :label].each do |method|
      expect(Settings.RELATIONSHIPS_SHOWN.MEMBER_OF_ANCESTORS).to respond_to(method)
    end
  end
end

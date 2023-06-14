# frozen_string_literal: true

require "spec_helper"

describe "Config" do
  it "Loads new v4.1 Settings defaults" do
    expect(Settings).to respond_to("RELATIONSHIPS_SHOWN")
    expect(Settings.FIELDS.DISPLAY_NOTE).to be_present
    expect(Settings.DISPLAY_NOTES_SHOWN).to respond_to(:danger)
    expect(Settings.SIDEBAR_STATIC_MAP).to include("iiif")

    [:field, :query_type, :icon, :label].each do |method|
      expect(Settings.RELATIONSHIPS_SHOWN.MEMBER_OF_ANCESTORS).to respond_to(method)
    end
  end
end

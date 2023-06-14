# frozen_string_literal: true

require "spec_helper"

describe "Config" do
  it "Loads new Aardvark relationships" do
    expect(Settings).to respond_to("RELATIONSHIPS_SHOWN")
    [:field, :query_type, :icon, :label].each do |method|
      expect(Settings.RELATIONSHIPS_SHOWN.MEMBER_OF_ANCESTORS).to respond_to(method)
    end
  end

  it "Loads new v3.4 Settings.FIELDS defaults" do
    expect(Settings.HOMEPAGE_MAP_GEOM).to be_nil
  end
end

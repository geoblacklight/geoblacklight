# frozen_string_literal: true

require "spec_helper"

class TestSuperClass
  def render_search_to_s(_params)
    "test"
  end
end

class GeoblacklightControllerTestClass < TestSuperClass
  include Geoblacklight::ViewHelperOverride
  include AbstractController::Translation
  attr_accessor :params
end

describe Geoblacklight::ViewHelperOverride do
  let(:fake_controller) do
    GeoblacklightControllerTestClass.new
  end

  describe "render_search_to_s_bbox" do
    it "returns an empty string for no bbox" do
      fake_controller.params = {}
      expect(fake_controller.render_search_to_s_bbox(fake_controller.params)).to eq ""
    end

    it "returns render_search_to_s_element when bbox is present" do
      fake_controller.params = {bbox: "123"}
      params = {"bbox" => "123"}
      expect(fake_controller).to receive(:render_search_to_s_element)
      expect(fake_controller).to receive(:render_filter_value)
      fake_controller.render_search_to_s_bbox(params)
    end

    it "calls the parent method" do
      expect(fake_controller.render_search_to_s({})).to eq "test"
    end
  end
end

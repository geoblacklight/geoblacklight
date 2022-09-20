# frozen_string_literal: true

require "spec_helper"

class GeoblacklightControllerTestClass
  include AbstractController::Translation
  attr_accessor :params
end

describe Geoblacklight::ViewHelperOverride do
  let(:fake_controller) do
    GeoblacklightControllerTestClass.new
      .extend(described_class)
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
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ViewerHelpTextComponent, type: :component do
  let(:feature) { "viewer_protocol" }
  let(:key) { "wms" }

  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(feature, key))
  end

  context "when the help text exists for an existing viewer protocol" do
    it "shows correct help text title for wms" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.wms.title"))
    end
  end

  context "when the help text is missing for a viewer protocol that exists" do
    before do
      allow(I18n).to receive(:exists?).and_return(false)
    end

    it "shows missing help text class" do
      expect(render_inline_to_capybara_node(described_class.new(feature, key))).to have_css(".translation-missing")
    end
  end
end

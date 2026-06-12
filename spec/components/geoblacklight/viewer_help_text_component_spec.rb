# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ViewerHelpTextComponent, type: :component do
  let(:feature) { "viewer_protocol" }
  let(:key) { "wms" }

  context "when the help text exists for an existing viewer protocol" do
    it "shows correct help text title for wms" do
      render_inline(described_class.new(feature, key))
      expect(page).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.wms.title"))
    end
  end

  context "when the help text is missing for a viewer protocol that exists" do
    before do
      allow(I18n).to receive(:exists?).and_return(false)
    end

    it "shows missing help text class" do
      render_inline(described_class.new(feature, key))
      expect(page).to have_css(".translation-missing")
    end
  end
end

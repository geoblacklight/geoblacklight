# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::DisplayNoteComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(**kwargs))
  end

  describe "prefixed" do
    let(:kwargs) { {display_note: "Warning: Full force applied."} }
    it "prefixed, includes display note and icon" do
      expect(rendered).to have_selector("div.gbl-display-note.alert.alert-warning")
      expect(rendered).to have_selector("span.blacklight-icons > svg")
      expect(rendered).to have_text("Warning: Full force applied.")
    end
  end

  describe "non-prefixed" do
    let(:kwargs) { {display_note: "Simple note."} }
    it "non-prefixed, includes only default display note" do
      expect(rendered).to have_selector("div.gbl-display-note.alert.alert-secondary")
      expect(rendered).to_not have_selector("span.blacklight-icons > svg")
      expect(rendered).to have_text("Simple note.")
    end
  end
end

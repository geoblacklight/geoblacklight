# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::AttributeTableComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new)
  end

  describe "displays attribute table" do
    it "displays attribute table body element" do
      expect(rendered).to have_selector(".attribute-table-body")
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::AttributeTableComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(**kwargs))
  end

  describe "displays attribute table based on condition" do
    let(:kwargs) { {show_attribute_table: true} }
    it "displays attribute table element" do
      expect(rendered).to have_selector(".attribute-table-body")
    end
  end

  describe "does not display table when it should not" do
    let(:kwargs) { {show_attribute_table: false} }
    it "does not attribute table" do
      expect(rendered).to_not have_selector(".attribute-table-body")
    end
  end
end

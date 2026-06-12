# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::AttributeTableComponent, type: :component do
  let(:document) { instance_double(SolrDocument, inspectable?: true) }

  before do
    allow_any_instance_of(GeoblacklightHelper).to receive(:document_available?).and_return(true)
  end

  it "displays attribute table body element" do
    render_inline(described_class.new(document:))
    expect(page).to have_selector(".attribute-table-body")
  end

  context "when the document is not inspectable" do
    before { allow(document).to receive(:inspectable?).and_return(false) }

    it "does not render the attribute table" do
      render_inline(described_class.new(document:))
      expect(page).not_to have_selector(".attribute-table-body")
    end
  end

  context "when the document is not available" do
    before do
      allow_any_instance_of(GeoblacklightHelper).to receive(:document_available?).and_return(false)
    end

    it "does not render the attribute table" do
      render_inline(described_class.new(document:))
      expect(page).not_to have_selector(".attribute-table-body")
    end
  end
end

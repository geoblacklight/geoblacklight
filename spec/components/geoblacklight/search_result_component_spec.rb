# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::SearchResultComponent, type: :component do
  let(:request_context) { double(document_index_view_type: "list", action_name: :index) }
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_index_field "gbl_wxsIdentifier_s"
      config.add_index_field "index_display"
      config.add_index_field "period"
      config.add_index_field "multi_display"
    end
  end
  let(:solr_fields) { Settings.FIELDS }
  let(:presenter) do
    Blacklight::DocumentPresenter.new(document, request_context, blacklight_config)
  end

  let(:document) do
    SolrDocument.new(
      id: 1,
      gbl_wxsIdentifier_s: "druid:abc123",
      non_index_field: "do not render",
      period: "Ends with period.",
      multi_display: %w[blue blah]
    )
  end
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document: presenter))
  end

  before do
    allow(request_context).to receive(:snippit)
    allow_any_instance_of(BlacklightHelper).to receive(:link_to_document)
    allow_any_instance_of(GeoblacklightHelper).to receive(:blacklight_config).and_return(blacklight_config)
  end

  describe "#index_fields_display" do
    let(:multi_valued_text) { document["multi_display"].join(" and ") }
    let(:combined_fields) { document["gbl_wxsIdentifier_s"] + ". " + document["period"] }

    subject(:index_fields_display) { rendered.find("[itemprop=description]").text }

    context "with multi-valued field" do
      it "each value is separated by comma" do
        expect(index_fields_display).to include(multi_valued_text)
      end
    end
    context "with document fields not configured as index field" do
      it "does not render" do
        expect(index_fields_display).not_to include(document["non_index_field"])
      end
    end
    context "with multiple document index fields present" do
      it "separates fields by period followed by a space" do
        expect(index_fields_display).to include(combined_fields)
      end
      context "with index field ending in period" do
        it "renders only 1 period" do
          expect(index_fields_display).to include(document["period"] + " ")
        end
      end
    end
    context "with document empty configured index field" do
      it "does not render a period followed by a space" do
        expect(index_fields_display).not_to include(". .")
      end
    end
  end
end

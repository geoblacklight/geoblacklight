# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::LoginLinkComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document: document))
  end
  let(:document) { instance_double(SolrDocument, id: 123) }

  context "when rendering is required" do
    before do
      allow_any_instance_of(GeoblacklightHelper).to receive(:document_available?).and_return(false)
      allow(document).to receive(:restricted?).and_return(true)
      allow(document).to receive(:same_institution?).and_return(true)
    end

    it "shows download link" do
      expect(rendered).to have_text(I18n.t("geoblacklight.tools.login_to_view"))
    end
  end

  context "when rendering is not required" do
    before do
      allow(document).to receive(:restricted?).and_return(false)
      allow(document).to receive(:same_institution?).and_return(false)
    end

    it "does not render anything" do
      expect(rendered).not_to have_text(I18n.t("geoblacklight.tools.login_to_view"))
    end
  end
end

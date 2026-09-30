# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::LoginLinkComponent, type: :component do
  let(:document) { instance_double(SolrDocument, id: 123, restricted?: true, same_institution?: true) }
  let(:login_path) { "/login" }

  before do
    allow(vc_test_controller).to receive(:blacklight_login_path).and_return(login_path)
    allow(vc_test_controller).to receive(:current_user).and_return(nil)
  end

  context "when the document is restricted to this institution and no one is signed in" do
    it "links to the sign-in page" do
      render_inline(described_class.new(document: document))
      expect(page).to have_link(I18n.t("geoblacklight.tools.login_to_view"), href: login_path)
    end
  end

  context "when signed in" do
    before do
      allow(vc_test_controller).to receive(:current_user).and_return(instance_double(ActiveRecord::Base))
    end

    it "does not render anything" do
      render_inline(described_class.new(document: document))
      expect(page).not_to have_text(I18n.t("geoblacklight.tools.login_to_view"))
    end
  end

  context "when the app has no authentication" do
    let(:login_path) { nil }

    it "does not render anything" do
      render_inline(described_class.new(document: document))
      expect(page).not_to have_text(I18n.t("geoblacklight.tools.login_to_view"))
    end
  end
end

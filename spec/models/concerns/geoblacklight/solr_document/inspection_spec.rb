# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::SolrDocument::Inspection do
  subject { SolrDocument.new }

  before do
    Geoblacklight::SolrDocument.warned_preview_methods.clear
    allow(Geoblacklight.deprecation).to receive(:warn)
  end

  describe "#inspectable?" do
    it "returns true for wms viewer protocol" do
      expect(subject).to receive(:viewer_protocol).and_return("wms")
      expect(subject.inspectable?).to be_truthy
    end

    it "returns false for iiif viewer protocol" do
      expect(subject).to receive(:viewer_protocol).and_return("iiif")
      expect(subject.inspectable?).to be_falsy
    end

    it "warns that GeoBlacklight 6 removes it, and nothing more" do
      subject.inspectable?

      expect(Geoblacklight.deprecation).to have_received(:warn).once.with(/SolrDocument#inspectable\? is removed/, anything)
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::GeoblacklightHelperBehavior do
  let(:dummy_class) do
    Class.new.extend(described_class)
  end
  let(:presenter) { instance_double(Geoblacklight::DocumentPresenter, index_fields_display: "druid:abc123") }

  describe "#geoblacklight_present" do
    before do
      expect(dummy_class).to receive(:presenter).and_return(presenter)
    end

    context "as a Symbol" do
      it "calls defined presenter class" do
        skip("@TODO: Find a way to pass :action_name thru")
        expect(dummy_class.geoblacklight_present(:index_fields_display)).to eq "druid:abc123"
      end
    end
    context "as a String" do
      it "calls defined presenter class" do
        skip("@TODO: Find a way to pass :action_name thru")
        expect(dummy_class.geoblacklight_present("index_fields_display")).to eq "druid:abc123"
      end
    end
  end
end

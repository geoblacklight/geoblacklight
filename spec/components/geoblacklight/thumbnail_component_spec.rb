# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ThumbnailComponent, type: :component do
  let(:url) { "http://example.com/thumb.jpg" }
  let(:fallback) { '<span class="blacklight-icons"></span>'.html_safe }
  let(:image_options) { {} }

  before do
    render_inline(described_class.new(url: url, fallback: fallback, image_options: image_options))
  end

  it "renders the fallback and the image together, so the fallback can show until the image loads" do
    expect(page).to have_css ".thumbnail-figure .thumbnail-fallback .blacklight-icons"
    expect(page).to have_css ".thumbnail-figure img.thumbnail-image[src='#{url}']"
  end

  it "loads the image lazily and leaves it out of the accessibility tree" do
    expect(page).to have_css "img[loading='lazy'][alt='']"
  end

  context "with image options from the application" do
    let(:image_options) { {alt: "A map of somewhere", class: "rounded", data: {"my-value" => "foo"}} }

    it "keeps them, without dropping the class that stacks the image over the fallback" do
      expect(page).to have_css "img.rounded.thumbnail-image[alt='A map of somewhere']"
      expect(page.find("img")["data-my-value"]).to eq "foo"
    end
  end
end

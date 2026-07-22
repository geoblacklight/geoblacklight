# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::MetadataDescriptionMarkdownComponent, type: :component do
  subject(:component) { described_class.new(field:, show: true) }

  let(:field) do
    instance_double(Blacklight::FieldPresenter,
      key: "dct_description_sm",
      label: "Description",
      render_field?: true,
      values: ["a **short**", "description"])
  end

  before do
    render_inline(component)
  end

  it "renders the description field" do
    expect(page).to have_css("dt.blacklight-dct_description_sm", text: "Description")
  end

  it "wraps the values in a truncate abstract" do
    expect(page).to have_css("div.truncate-abstract[data-read-more-text='Read more'][data-close-text='Close']")
  end

  it "transforms each markdown value into HTML" do
    expect(page).to have_css("div.truncate-abstract p", count: 2)
    expect(page).to have_css("div.truncate-abstract p strong", text: "short")
  end

  describe "#markdown_to_html" do
    it "transforms markdown into HTML" do
      expect(component.markdown_to_html("a **short** description")).to eq "<p>a <strong>short</strong> description</p>\n"
    end
  end
end

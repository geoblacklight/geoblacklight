# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::TruncatableMetadataFieldLayoutComponent, type: :component do
  subject(:component) { described_class.new(field:) }

  let(:field_config) { Blacklight::Configuration::Field.new(key: "dct_subject_sm") }
  let(:field) { instance_double(Blacklight::FieldPresenter, key: "dct_subject_sm", field_config:) }

  def render_field(component)
    render_inline(component) do |layout|
      layout.with_label { "Subject" }
      layout.with_value(value: "Forests", index: 0)
      layout.with_value(value: "Land use", index: 1)
    end
  end

  it "wraps the label and the values in a row of their own" do
    render_field(component)

    expect(page).to have_css("div.truncate-field.row > dt.blacklight-dct_subject_sm", text: "Subject")
    expect(page).to have_css("div.truncate-field.row > dd", count: 3) # two values plus the button slot
  end

  it "keeps each value in its own dd, in the columns the layout would have used" do
    render_field(component)

    expect(page).to have_css("dd.col-md-9.blacklight-dct_subject_sm", text: "Forests")
    expect(page).to have_css("dd.offset-md-3.col-md-9.blacklight-dct_subject_sm", text: "Land use")
  end

  it "renders an empty dd for the initializer to put the button in" do
    render_field(component)

    # A <dl> may not hold a bare <button>, so the button cannot be a sibling of the values
    expect(page).to have_css("div.truncate-field > dd.read-more-slot.offset-md-3.col-md-9")
    expect(page.find("dd.read-more-slot").text).to be_empty
  end

  it "sets up the data attributes for the JS initializer" do
    render_field(component)

    expect(page).to have_css(
      ".truncate-field[data-limit='5'][data-read-more-text='Read more'][data-close-text='Close']"
    )
    expect(page).to have_css(".truncate-field[data-button-label*='assistive technology']")
  end

  context "when the truncation parameters are given to the component" do
    subject(:component) do
      described_class.new(field:, limit: 2, read_more_text: "More", close_text: "Less")
    end

    it "uses them instead of the defaults" do
      render_field(component)

      expect(page).to have_css(
        ".truncate-field[data-limit='2'][data-read-more-text='More'][data-close-text='Less']"
      )
    end
  end

  context "when the field configuration sets a limit" do
    let(:field_config) { Blacklight::Configuration::Field.new(key: "dct_subject_sm", limit: 3) }

    it "uses the configured limit" do
      render_field(component)

      expect(page).to have_css(".truncate-field[data-limit='3']")
    end
  end

  context "when the layout is given different columns" do
    subject(:component) { described_class.new(field:, label_class: "col-2", value_class: "col-10", offset_class: "offset-2") }

    it "puts the button slot in the same columns as the values" do
      render_field(component)

      expect(page).to have_css("dd.read-more-slot.offset-2.col-10")
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Metadata fields that limit their values" do
  let(:group) { "div.truncate-field:has(dt.blacklight-dct_subject_sm)" }
  let(:read_more) { find("#{group} > dd.read-more-slot button") }

  # Princeton record carrying nine subject values, four more than the five it shows in full
  scenario "The values past the limit are hidden until the reader asks for them", js: true do
    visit solr_document_path("princeton-dc7h14b252v")

    subjects = find(group)

    # Every value keeps its own dd. The value at the limit is clipped to show that the list
    # carries on; the ones after it are taken out of view entirely.
    expect(subjects).to have_css("dd:not(.read-more-slot)", count: 9, visible: :all)
    expect(subjects).to have_css("dd.truncate-preview", count: 1, visible: :all)
    expect(subjects).to have_css("dd.visually-hidden", count: 3, visible: :all)

    # The text assertions are scoped to the field: the viewer's own metadata panel lists
    # every subject too, so a page-wide matcher would race with the viewer loading.
    expect(subjects).to have_no_text("Physical maps")

    read_more.click

    expect(subjects).to have_no_css("dd.visually-hidden", visible: :all)
    expect(subjects).to have_no_css("dd.truncate-preview", visible: :all)
    expect(subjects).to have_text("Physical maps")
    expect(read_more).to have_text("Close")

    read_more.click

    expect(subjects).to have_css("dd.visually-hidden", count: 3, visible: :all)
    expect(subjects).to have_css("dd.truncate-preview", count: 1, visible: :all)
    expect(read_more).to have_text("Read more")
  end

  scenario "The clipped value fades out, the way a clamped description does", js: true do
    visit solr_document_path("princeton-dc7h14b252v")

    preview = find("#{group} > dd.truncate-preview", visible: :all)
    expect(preview.evaluate_script("getComputedStyle(this, '::after').backgroundImage")).to include "linear-gradient"

    # A shade under one line tall, so the value reads as cut off rather than as its own entry
    line_height = preview.evaluate_script("parseFloat(getComputedStyle(this).lineHeight)")
    expect(preview.evaluate_script("this.getBoundingClientRect().height")).to be < line_height

    # The gradient covers the value, so it must not swallow clicks on the link beneath it
    expect(preview.evaluate_script("getComputedStyle(this, '::after').pointerEvents")).to eq "none"
  end

  scenario "The hidden values stay available to assistive technology", js: true do
    visit solr_document_path("princeton-dc7h14b252v")

    # visually-hidden leaves the values in the accessibility tree, so the button is of no use
    # to assistive technology and says so rather than promising something it cannot deliver
    expect(read_more[:"aria-disabled"]).to eq "true"
    expect(read_more[:"aria-label"]).to include "assistive technology"

    hidden = all("#{group} > dd.visually-hidden", visible: :all).last
    expect(hidden.evaluate_script("getComputedStyle(this).display")).not_to eq "none"
    expect(hidden.evaluate_script("getComputedStyle(this).visibility")).not_to eq "hidden"
  end

  scenario "Fields short enough to fit are left alone", js: true do
    visit solr_document_path("princeton-dc7h14b252v")

    # Wait for the initializer to have run before asserting that it skipped this field
    expect(page).to have_css("#{group} > dd.read-more-slot button")

    spatial = "div.truncate-field:has(dt.blacklight-dct_spatial_sm)"
    expect(page).to have_no_css("#{spatial} > dd.read-more-slot button")
    expect(page).to have_no_css("#{spatial} > dd.visually-hidden", visible: :all)
    expect(page).to have_no_css("#{spatial} > dd.truncate-preview", visible: :all)
  end
end

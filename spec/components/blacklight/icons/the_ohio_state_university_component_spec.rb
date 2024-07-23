# frozen_string_literal: true

require "spec_helper"

RSpec.describe Blacklight::Icons::TheOhioStateUniversityComponent, type: :component do
  let(:component) { described_class.new(name: "the-ohio-state-university") }
  let(:rendered) { render_inline_to_capybara_node(component) }

  it "has the correct title" do
    expect(rendered).to have_css("title")
    expect(rendered).to have_css("svg")
    expect(rendered).to have_css(".blacklight-icons")
    expect(rendered.find("title").text).to eq "The Ohio State University"
  end
end

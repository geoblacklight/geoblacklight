# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Viewer theme", js: true do
  context "the item page's viewer" do
    before { visit solr_document_path("stanford-bc576pk4911") }

    scenario "starts out in the page's color mode" do
      # No attribute is Bootstrap's light default when Blacklight's color-mode support is off
      mode = page.evaluate_script("document.documentElement.getAttribute('data-bs-theme')") || "light"
      expect(page).to have_css(%(ogm-viewer[theme="#{mode}"]))
    end

    scenario "follows Bootstrap's color mode" do
      select_theme "dark"
      expect(page).to have_css('ogm-viewer[theme="dark"]')

      select_theme "light"
      expect(page).to have_css('ogm-viewer[theme="light"]')
    end
  end

  context "the overview map" do
    before { visit root_path }

    scenario "follows Bootstrap's color mode as well" do
      select_theme "dark"
      expect(page).to have_css('ogm-overview[theme="dark"]')

      select_theme "light"
      expect(page).to have_css('ogm-overview[theme="light"]')
    end
  end

  context "the locator map" do
    before { visit solr_document_path("princeton-1r66j405w") }

    scenario "follows Bootstrap's color mode as well" do
      select_theme "dark"
      expect(page).to have_css('ogm-locator[theme="dark"]')

      select_theme "light"
      expect(page).to have_css('ogm-locator[theme="light"]')
    end
  end

  def select_theme(theme)
    page.execute_script("document.documentElement.setAttribute('data-bs-theme', arguments[0])", theme)
  end
end

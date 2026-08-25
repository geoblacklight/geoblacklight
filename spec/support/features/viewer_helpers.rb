# frozen_string_literal: true

module Features
  module ViewerHelpers
    # What the item viewer offers to show, as the labels on its tabs. It works these out from the
    # record's references once it has fetched the record, inside its own shadow root, so this waits
    # for them rather than expecting them to be there when the page arrives.
    def preview_tabs(wait: 20)
      page.document.synchronize(wait) do
        page.evaluate_script(<<~JS) || raise(Capybara::ElementNotFound)
          (() => {
            const previews = document.querySelector("ogm-viewer")?.shadowRoot?.querySelector("ogm-previews")
            const tabs = previews?.shadowRoot?.querySelectorAll("wa-tab")
            return tabs?.length ? Array.from(tabs).map((tab) => tab.textContent.trim()) : null
          })()
        JS
      end
    end
  end
end

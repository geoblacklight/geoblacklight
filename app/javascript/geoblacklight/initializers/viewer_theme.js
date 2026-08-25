// Keep any viewers on the page in the same color mode as the rest of the page.
// Bootstrap's mode lives in data-bs-theme on <html>, set by Blacklight's theme switcher; the viewer
// takes a "theme" attribute. Blacklight resolves "auto" against prefers-color-scheme before writing
// the attribute, so the value we read is always either "light" or "dark".

// Apply the current color mode to every viewer and overview on the page
function syncViewerTheme() {
  const theme = document.documentElement.getAttribute("data-bs-theme")

  // No attribute means the host app has dark mode support turned off
  if (!theme) return

  // Every kind of map the viewer offers: the previewer, the map of where a set of records is, and
  // the map of where one of them is. All three take the same attribute.
  document
    .querySelectorAll("ogm-viewer, ogm-overview, ogm-locator")
    .forEach((viewer) => viewer.setAttribute("theme", theme))
}

// Follow the switcher after load. <html> outlives Turbo navigation, so one observer covers every
// page: re-observing the same node with the same options replaces the registration instead of
// stacking up another one, which is what makes this safe to call on each turbo:load.
const observer = new MutationObserver(syncViewerTheme)

export default function initializeViewerTheme() {
  syncViewerTheme()
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ["data-bs-theme"] })
}

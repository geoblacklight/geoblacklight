import { Controller } from "@hotwired/stimulus"

// Which row is being hovered
const RESULTS = "#documents[data-overview-map-results]"
const ROW = `${RESULTS} [data-document-counter]`

// Controller used for the search results map
// NOTE: the map is turbo-permanent to prevent flashing on reload
export default class OverviewMapController extends Controller {
  static values = {
    catalogUrl: String,
  }

  connect() {
    this.element.searchBounds = this.boundsMarker()?.dataset.bounds || undefined
    this.load()
  }

  disconnect() {
    this.unwatchResults()
  }

  boundsMarker() {
    return document.getElementById(`${this.element.id}-bounds`)
  }

  async load() {
    // Imported here rather than at the top of the file: this library re-exports everything the
    // viewer can draw, including the previewers the components themselves load only on demand, so
    // naming it statically would put all of that on every page that loads GeoBlacklight. Here it
    // arrives with the map, and only on the pages that have one.
    const [library] = await Promise.all([import("ogm-viewer/lib"), customElements.whenDefined("ogm-overview")])

    // Taken off the page while we waited, by a Turbo visit to somewhere else
    if (!this.element.isConnected) return

    // Build previewable objects from every result's geometry
    this.element.previewers = this.locations(library, this.results())

    // Bind event handling for highlighting search result rows
    if (this.rows().length) this.watchResults()
  }

  // Build a resource and previewer (container for geometry) for each search result.
  // NOTE: results with no geometry still have to take up a number, because the
  // numbering has to match the search result list.
  locations({ LocationPreviewer, LocationResource }, results) {
    const places = results.map(({ place }) => Number(place)).filter((place) => place)
    const locations = Array.from({ length: places.length ? Math.max(...places) : 0 })

    results.forEach(({ id, place, geometry }) => {
      if (!place || !geometry) return

      locations[place - 1] = new LocationPreviewer(new LocationResource(id, geometry))
    })

    return locations
  }

  // Parse data coming in from GBL in the template. This gets reset on each
  // load of search results and doesn't use turbo.
  results() {
    const json = document.querySelector(RESULTS)?.dataset.overviewMapResults
    return json ? JSON.parse(json) : []
  }

  // Execute the search when you drag a box on the map. The event that gets
  // emitted by the map contains the bounding box as its `detail`.
  search({ detail: bounds }) {
    const url = new URL(this.catalogUrlValue, window.location)

    // Go back to page 1, and replace the existing query, if there is one
    const params = new URL(window.location).searchParams
    params.delete("page")
    params.set("bbox", bounds.join(" "))
    url.search = params.toString()

    this.visit(url)
  }

  // When you hover over a number on the map, also highlight that row in the
  // search results (apply .highlighted class)
  highlight({ detail }) {
    this.rows().forEach((row) => {
      const marked = detail && (this.layerId(row) === detail.id || this.place(row) === detail.place)
      row.classList.toggle("highlighted", Boolean(marked))
    })
  }

  // Reverse of highlight(): when you hover over a row in the search results,
  // focus that number on the map
  handlePointer = (event) => {
    const row = event.target instanceof Element ? event.target.closest(ROW) : null
    this.element.highlighted = row ? this.layerId(row) : undefined
  }

  watchResults() {
    document.addEventListener("mouseover", this.handlePointer)
    document.addEventListener("focusin", this.handlePointer)
  }

  unwatchResults() {
    document.removeEventListener("mouseover", this.handlePointer)
    document.removeEventListener("focusin", this.handlePointer)
  }

  // Rows are consulted only for the two-way pointer/focus highlight. Geometry, ids and numbering used
  // to build the map all come from results() instead.
  rows() {
    return Array.from(document.querySelectorAll(ROW))
  }

  // The number shown beside a result, which is the number the map draws for it
  place(row) {
    return Number(row.dataset.documentCounter) || undefined
  }

  layerId(row) {
    return row.dataset.mapId
  }

  // Turbo when it's there, and in place when the reader is already on the page they're searching: the
  // page renders again around them, so their scroll position - and the map they are working in - stays
  // where it was. A search from anywhere else is a navigation like any other, and lands at the top.
  visit(url) {
    if (typeof Turbo === "undefined") {
      window.location.href = url
      return
    }

    if (url.pathname === window.location.pathname) {
      document.addEventListener(
        "turbo:before-render",
        () => {
          if (Turbo.navigator.currentVisit) Turbo.navigator.currentVisit.scrolled = true
        },
        { once: true },
      )
    }

    Turbo.visit(url)
  }
}

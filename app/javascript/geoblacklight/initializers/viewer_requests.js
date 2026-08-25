// Initializer for helping the viewer make authenticated requests for restricted data.

// List of registered request transform functions
const registered = []

/**
 * Register a transform, from a built GBL app's JavaScript entrypoint:
 *
 *   Geoblacklight.onViewerRequest((url, resourceType) => {
 *     if (!url.startsWith("https://geo.example.edu/restricted/")) return
 *     return { headers: { Authorization: `Bearer ${token}` } }
 *   })
 *
 * Answer with `{ headers }`, `{ credentials: "include" }`, or `{ url }` to send the request
 * somewhere else - a proxy on this application's own origin, say, which can authenticate with the
 * service using credentials the browser never sees. Return nothing to leave a request alone.
 *
 * Always check the URL first; the viewer uses the transform for tile and basemap requests too,
 * and you probably don't want to redirect or send cookies to those.
 *
 * Answer synchronously: this runs inline as the reader pans and zooms, so anything it needs - a
 * token, say - has to already be in hand rather than fetched here.
 *
 * @param {(url: string, resourceType: "metadata" | "tile") => object | undefined} transform
 */
export function onViewerRequest(transform) {
  registered.push(transform)
}

// URLs where we know we need to send credentials. This gets set via GBL's
// configuration as a data attribute on the viewer.
function restrictedOrigins(viewer) {
  if (!viewer.dataset.restrictedOrigins) return []
  return JSON.parse(viewer.dataset.restrictedOrigins)
}

// Pick the transform to use for a given request. The first registered transform
// that returns a value will be used.
//
// If there weren't any registered transforms but we know the request is to a
// restricted origin, use a default transform that sends credentials (cookies).
function transformFor(origins) {
  return (url, resourceType) => {
    for (const transform of registered) {
      const transformed = transform(url, resourceType)
      if (transformed) return transformed
    }

    if (origins.some((origin) => url.startsWith(origin))) return { credentials: "include" }
  }
}

// On load, find all the viewers in the page and set up request transforms for them.
export default function initializeViewerRequests() {
  document.querySelectorAll("ogm-viewer").forEach((viewer) => {
    const origins = restrictedOrigins(viewer)
    if (!registered.length && !origins.length) return

    viewer.requestTransform = transformFor(origins)
  })
}

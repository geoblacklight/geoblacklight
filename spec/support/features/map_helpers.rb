# frozen_string_literal: true

require "cgi"

module Features
  module MapHelpers
    # An overview or locator map, once it has something on it. Both are handed what to draw a moment
    # after the page arrives - a locator fetches its own record, and an overview's controller imports
    # the library it draws with - so anything that reads or points at a map has to wait for that
    # rather than for the page.
    def map_ready(selector = "#overview-map", wait: 20)
      map = find(selector)
      expect(map.shadow_root).to have_css("canvas.maplibregl-canvas", wait: wait)

      # And until there is something to draw, which may well be nothing: a map with no results to
      # put on it - the home page's - has still been given its records.
      page.document.synchronize(wait) do
        given = page.evaluate_script(
          "arguments[0].record !== undefined || arguments[0].previewers !== undefined || arguments[0].previewer !== undefined", map
        )
        raise(Capybara::ElementNotFound) unless given
      end

      map
    end

    # What the map has been given to draw, as a west/south, east/north pair per result, in the order
    # their numbers put them, with nil where a result had nowhere to be drawn. A locator holds one
    # record rather than a list, and reports the same shape around it: a single-entry array, worked
    # out from the record's own geometry rather than asked of a previewer, since none is exposed.
    def drawn_extents(selector = "#overview-map")
      page.evaluate_async_script(<<~JS, map_ready(selector))
        const [map, done] = arguments

        if (map.record) {
          const geometry = map.record.getGeometry()
          const points = geometry?.coordinates?.[0] ?? []
          if (!points.length) return done([null])

          const lngs = points.map(([lng]) => lng)
          const lats = points.map(([, lat]) => lat)
          return done([[[Math.min(...lngs), Math.min(...lats)], [Math.max(...lngs), Math.max(...lats)]]])
        }

        const drawn = map.previewers ?? [map.previewer]
        Promise.all(Array.from(drawn, (previewer) => previewer?.getBounds() ?? null)).then(done)
      JS
    end

    # Search the map the way a reader does: hold shift and drag a box over the middle of it. There is
    # no control to click - the gesture is the whole of it - so this is a real mouse drag.
    def search_map_area(selector = "#overview-map", size: 80)
      map = map_ready(selector)

      page.driver.browser.action
        .move_to(map.native, -size / 2, -size / 2)
        .key_down(:shift)
        .click_and_hold
        .move_by(size, size)
        .release
        .key_up(:shift)
        .perform
    end

    # The area the query on screen asked after, as the bbox parameter states it
    def searched_bbox
      CGI.parse(URI(page.current_url).query.to_s)["bbox"].first
    end
  end
end

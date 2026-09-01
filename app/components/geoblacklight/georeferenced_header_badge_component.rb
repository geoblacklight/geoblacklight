# frozen_string_literal: true

module Geoblacklight
  # Badge that indicates the data is georeferenced
  class GeoreferencedHeaderBadgeComponent < HeaderBadgeComponent
    # Don't render for empty or false values
    def render?
      @document.georeferenced?
    end

    # Without this, the badge would show "true" for the label
    def label
      t("geoblacklight.badges.georeferenced")
    end
  end
end

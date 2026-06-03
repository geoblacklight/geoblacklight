# frozen_string_literal: true

module Geoblacklight
  class IiifDragDropComponent < ViewComponent::Base
    def initialize(document:)
      super()
      manifest_ref = document.item_viewer&.iiif_manifest
      @manifest = manifest_ref&.endpoint || ""
      @href_link = Geoblacklight.configuration.iiif_drag_drop_link&.gsub("@manifest", @manifest)
    end

    def render?
      Geoblacklight.configuration.iiif_drag_drop_link.present? && @manifest.present?
    end
  end
end

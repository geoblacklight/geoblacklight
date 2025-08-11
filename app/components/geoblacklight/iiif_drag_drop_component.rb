# frozen_string_literal: true

module Geoblacklight
  class IiifDragDropComponent < ViewComponent::Base
    def initialize(document:)
      super()
      manifest_ref = document.item_viewer&.iiif_manifest
      @manifest = manifest_ref&.endpoint || ""
      @href_link = Settings.IIIF_DRAG_DROP_LINK&.gsub("@manifest", @manifest)
    end

    def render?
      Settings.IIIF_DRAG_DROP_LINK.present? && @manifest.present?
    end
  end
end

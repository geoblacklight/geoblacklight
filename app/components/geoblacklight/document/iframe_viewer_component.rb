# frozen_string_literal: true

module Geoblacklight
  module Document
    # Renders an embedded viewer for a document using an iframe
    class IframeViewerComponent < ViewComponent::Base
      DEFAULT_ATTRS = {
        loading: "lazy",
        allowfullscreen: true,
        referrerpolicy: "strict-origin-when-cross-origin",
        sandbox: "allow-scripts allow-same-origin allow-forms allow-popups allow-popups-to-escape-sandbox allow-downloads"
      }.freeze

      attr_reader :iframe_attrs

      def initialize(document:, iframe_attrs: {})
        @document = document
        @iframe_attrs = DEFAULT_ATTRS.merge(iframe_attrs)
        super()
      end

      def iframe_url
        @document.references.iframe.endpoint
      end

      def iframe_title
        helpers.t("geoblacklight.embed.title", title: @document.title)
      end

      def render?
        @document.previewable_via?(:iframe)
      end
    end
  end
end

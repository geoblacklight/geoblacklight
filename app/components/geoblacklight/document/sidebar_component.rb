# frozen_string_literal: true

module Geoblacklight
  module Document
    class SidebarComponent < Blacklight::Document::SidebarComponent
      # @deprecated
      def render_static_map_component
        render Geoblacklight::StaticMapComponent.new(document:)
      end

      # @deprecated
      def sidebar_buttons
        [
          Geoblacklight::WebServicesLinkComponent.new(document:),
          Geoblacklight::DownloadLinksComponent.new(document:),
          Geoblacklight::LoginLinkComponent.new(document:)
        ]
      end

      # @deprecated
      def render_more_like_this
        render Blacklight::Document::MoreLikeThisComponent.new(document:)
      end
      Geoblacklight.deprecation.deprecate_methods(Geoblacklight::Document::SidebarComponent,
        render_static_map_component: "GeoBlacklight 6 builds the sidebar from a single #panels method",
        sidebar_buttons: "GeoBlacklight 6 builds the sidebar from a single #panels method",
        render_more_like_this: "GeoBlacklight 6 builds the sidebar from a single #panels method")
    end
  end
end

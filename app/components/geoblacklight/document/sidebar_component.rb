# frozen_string_literal: true

module Geoblacklight
  module Document
    class SidebarComponent < Blacklight::Document::SidebarComponent
      def render_static_map_component
        render Geoblacklight::StaticMapComponent.new(document:)
      end

      def sidebar_buttons
        [
          Geoblacklight::WebServicesLinkComponent.new(document:),
          Geoblacklight::DownloadLinksComponent.new(document:),
          Geoblacklight::LoginLinkComponent.new(document:)
        ]
      end

      def render_more_like_this
        render Blacklight::Document::MoreLikeThisComponent.new(document:)
      end
    end
  end
end

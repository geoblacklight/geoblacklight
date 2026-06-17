# frozen_string_literal: true

module Geoblacklight
  module Document
    class SidebarComponent < Blacklight::Document::SidebarComponent
      def panels
        [
          Geoblacklight::DownloadLinksComponent.new(document:),
          Geoblacklight::LoginLinkComponent.new(document:),
          Geoblacklight::StaticMapComponent.new(document:),
          Blacklight::Document::MoreLikeThisComponent.new(document:)
        ]
      end
    end
  end
end

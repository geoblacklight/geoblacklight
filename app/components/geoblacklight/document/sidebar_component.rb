# frozen_string_literal: true

module Geoblacklight
  module Document
    class SidebarComponent < Blacklight::Document::SidebarComponent
      def panels
        [
          Geoblacklight::StaticMapComponent.new(document:),
          Geoblacklight::Document::DownloadLinksComponent.new(document:),
          Geoblacklight::LoginLinkComponent.new(document:),
          Geoblacklight::Document::RelationsContainerComponent.new(document: document),
          Blacklight::Document::MoreLikeThisComponent.new(document:)
        ]
      end
    end
  end
end

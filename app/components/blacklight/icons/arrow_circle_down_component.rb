# frozen_string_literal: true

module Blacklight
  module Icons
    class ArrowCircleDownComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M20.06 14.02c0-.27-.1-.52-.28-.7l-1.42-1.43c-.19-.19-.44-.28-.7-.28s-.52.1-.7.28L14 14.84V7a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v7.84L7.05 11.9c-.19-.19-.44-.3-.7-.3s-.52.11-.7.3l-1.43 1.42c-.19.19-.28.44-.28.7s.1.52.28.7l7.08 7.09c.18.18.44.28.7.28s.52-.1.7-.28l7.08-7.08a.98.98 0 0 0 .28-.7zM24 14a12 12 0 1 1-24 0 12 12 0 0 1 24 0z"/>
          </svg>
        SVG
      end

      def title
        key = "blacklight.icon.#{name}"
        t(key)
      end
    end
  end
end

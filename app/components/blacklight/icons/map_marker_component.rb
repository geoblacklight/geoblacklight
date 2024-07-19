# frozen_string_literal: true

module Blacklight
  module Icons
    class MapMarkerComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M12 10a4 4 0 0 0-8 0 4 4 0 0 0 8 0zm4 0c0 .95-.1 1.94-.52 2.8L9.8 24.9C9.47 25.57 8.75 26 8 26s-1.47-.42-1.78-1.1L.52 12.8A6.55 6.55 0 0 1 0 10a8 8 0 1 1 16 0z"/>
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

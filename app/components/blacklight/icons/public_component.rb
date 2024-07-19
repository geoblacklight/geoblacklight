# frozen_string_literal: true

module Blacklight
  module Icons
    class PublicComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 26 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M26 9v4a1 1 0 0 1-1 1h-1a1 1 0 0 1-1-1V9a4 4 0 0 0-8 0v3h1.5c.83 0 1.5.67 1.5 1.5v9c0 .83-.67 1.5-1.5 1.5h-15A1.5 1.5 0 0 1 0 22.5v-9c0-.83.67-1.5 1.5-1.5H12V9a7 7 0 0 1 14 0z"/>
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

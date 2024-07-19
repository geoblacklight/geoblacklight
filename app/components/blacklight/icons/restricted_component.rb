# frozen_string_literal: true

module Blacklight
  module Icons
    class RestrictedComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 18 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M5 12h8V9a4 4 0 0 0-8 0v3zm13 1.5v9c0 .83-.67 1.5-1.5 1.5h-15A1.5 1.5 0 0 1 0 22.5v-9c0-.83.67-1.5 1.5-1.5H2V9c0-3.84 3.16-7 7-7s7 3.16 7 7v3h.5c.83 0 1.5.67 1.5 1.5z"/>
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

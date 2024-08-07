# frozen_string_literal: true

module Blacklight
  module Icons
    class UclaComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M2.98 22.26c-.08-1.12 0-2.7 0-3.48L4.62 0h6.15L9.04 18.93c-.36 4.13 1.26 7.02 5.34 7.02 4.16 0 6.42-2.94 6.78-6.6L22.9 0h6.15l-1.71 19.1C26.7 26.5 21.8 32 13.94 32 7.78 32 3.8 28.01 2.98 22.27z"/>
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

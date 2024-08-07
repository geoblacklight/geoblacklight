# frozen_string_literal: true

module Blacklight
  module Icons
    class PolylineComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="none" stroke="#6c757d" stroke-miterlimit="10" stroke-width="1.52" d="M13.4.76h6.34v6.33H13.4V.76zM.76 24.9h6.33v6.34H.76v-6.33z"/>
          	<path fill="none" stroke="#6c757d" stroke-miterlimit="10" stroke-width="3.04" d="M7.1 24.9L16 7.1"/>
          	<path fill="none" stroke="#6c757d" stroke-miterlimit="10" stroke-width="1.52" d="M24.8 15.96h6.34v6.33H24.8v-6.33z"/>
          	<path fill="none" stroke="#6c757d" stroke-miterlimit="10" stroke-width="3.04" d="M25.07 16.39l-6.99-9.37"/>
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

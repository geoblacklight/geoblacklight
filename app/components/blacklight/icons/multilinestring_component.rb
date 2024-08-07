# frozen_string_literal: true

module Blacklight
  module Icons
    class MultilinestringComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 32">
          	<title>#{title}</title>
          	<path fill="none" stroke="#6c757d" stroke-width="1.73" d="M19.1 8.07h4.8v4.79h-4.8V8.07zM.86 26.32h4.79v4.78H.86v-4.78z"/>
          	<path fill="none" stroke="#6c757d" stroke-width="3.46" d="M5.65 26.32l13.46-13.46"/>
          	<path fill="none" stroke="#6c757d" stroke-width="1.73" d="M16.43 22.49h4.79v4.78h-4.79V22.5zM.86.86h4.79v4.79H.86V.86z"/>
          	<path fill="none" stroke="#6c757d" stroke-width="3.46" d="M5.48 5.48l10.95 17"/>
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

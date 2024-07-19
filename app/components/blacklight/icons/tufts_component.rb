# frozen_string_literal: true

module Blacklight
  module Icons
    class TuftsComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 29 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M4.58 5.12h5.96v22.4H5.62V32h17.31v-4.49h-4.91V5.15h6.1v7.28h4.5V0H0v12.43h4.58z"/>
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

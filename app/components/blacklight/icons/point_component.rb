# frozen_string_literal: true

module Blacklight
  module Icons
    class PointComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M20.22 11.25q0-1.89-1.34-3.23t-3.23-1.34-3.23 1.34-1.34 3.23 1.34 3.24 3.23 1.33 3.23-1.33 1.34-3.24zm4.57 0q0 1.95-.58 3.2l-6.5 13.82q-.3.59-.85.93t-1.2.34-1.21-.34-.83-.93L7.1 14.45q-.59-1.25-.59-3.2 0-3.78 2.68-6.46t6.46-2.68 6.47 2.68 2.68 6.46z"/>
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

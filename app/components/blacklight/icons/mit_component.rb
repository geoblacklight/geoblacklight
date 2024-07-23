# frozen_string_literal: true

module Blacklight
  module Icons
    class MitComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 29 32">
          	<title>#{title}</title>
          	<path fill="none" stroke="#6c757d" stroke-width="6.75" d="M3.37 0v32M14.36 0v21.78M25.35 0v32"/>
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

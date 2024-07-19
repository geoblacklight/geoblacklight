# frozen_string_literal: true

module Blacklight
  module Icons
    class IndianaComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M0 0h27.36v32H0V0zm16.74 7.7v1.7h1.17v9.46h-2.49V6.39h1.32v-1.7h-6.2v1.7h1.32v12.47H9.34V9.4h1.18V7.7H4.7v1.7H6v10.96l2.15 2.2h3.7v2.52h-1.31v2.18h6.2v-2.18h-1.32v-2.52h3.69l2.13-2.2V9.4h1.34V7.7h-5.84z"/>
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

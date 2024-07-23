# frozen_string_literal: true

module Blacklight
  module Icons
    class LeafComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M20 11a1 1 0 0 0-1-1c-5.53 0-9.1 2.31-12.7 6.3a1 1 0 0 0-.3.7 1 1 0 1 0 1.7.7c.77-.68 1.46-1.43 2.2-2.14C12.74 13.01 15.17 12 19 12a1 1 0 0 0 1-1zm8-3.1c0 1-.1 2.02-.31 3.02-1 4.86-4.13 8.02-8.47 10.17a15.33 15.33 0 0 1-6.85 1.7c-1.5 0-3.04-.26-4.46-.74-.75-.25-2.25-1.24-2.88-1.24-.78 0-1.72 3.19-3.08 3.19-.98 0-1.28-.48-1.7-1.2-.14-.27-.25-.36-.25-.7 0-1.62 3.1-2.88 3.1-3.79 0-.14-.41-.97-.48-1.28a9.35 9.35 0 0 1-.14-1.62c0-4.97 3.96-8.52 8.4-9.99 3.2-1.06 10.01.17 12.18-1.89.86-.8 1.28-1.53 2.6-1.53C27.42 2 28 6.58 28 7.9z"/>
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

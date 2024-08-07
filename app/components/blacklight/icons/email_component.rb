# frozen_string_literal: true

module Blacklight
  module Icons
    class EmailComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M28 11.1v12.4a2.5 2.5 0 0 1-2.5 2.5h-23A2.5 2.5 0 0 1 0 23.5V11.1c.47.51 1 .96 1.58 1.35 2.6 1.77 5.22 3.53 7.76 5.4 1.32.96 2.94 2.15 4.64 2.15h.04c1.7 0 3.32-1.19 4.64-2.16 2.54-1.84 5.17-3.62 7.78-5.39.56-.39 1.1-.84 1.56-1.36zm0-4.6c0 1.75-1.3 3.33-2.67 4.28-2.44 1.69-4.9 3.38-7.31 5.08-1.02.7-2.74 2.14-4 2.14h-.04c-1.26 0-2.98-1.44-4-2.14-2.42-1.7-4.87-3.4-7.3-5.08C1.59 10.03 0 8.26 0 6.84 0 5.31.83 4 2.5 4h23C26.86 4 28 5.12 28 6.5z"/>
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

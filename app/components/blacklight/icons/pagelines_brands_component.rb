# frozen_string_literal: true

module Blacklight
  module Icons
    class PagelinesBrandsComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M24 19.54c-3.44 8.55-11.7 3.38-11.7 3.38-2.53 5.11-6.7 8.4-11.53 8.42-1 0-1.04-1.53 0-1.53 4.02-.02 7.53-2.67 9.82-6.88-2.57 1-7.4 1.75-10.1-5.13 6.82-2.81 9.95.7 11.15 2.84a22.68 22.68 0 0 0 1.35-4.98s-8.73 1.37-9.35-6.13c7.45-3 9.54 4.8 9.54 4.8.1-1.05.2-3.3.2-3.35 0 0-6.64-4.6-2.37-10.32 7.78 2.69 3.83 10.15 3.83 10.15.03.1.03 1.49 0 2.09 0 0 2.83-5.57 8.53-3.6-.26 8.38-8.87 6.65-8.87 6.65-.28 1.71-.7 3.34-1.25 4.85 0 0 5.19-5.74 10.75-1.25z"/>
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

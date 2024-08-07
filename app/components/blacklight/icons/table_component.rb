# frozen_string_literal: true

module Blacklight
  module Icons
    class TableComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 41 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M1.55.01C.67.11.01.86.01 1.74v27.68c0 .95.78 1.73 1.73 1.73h36.33c.95 0 1.73-.78 1.73-1.73V1.74c0-.95-.78-1.73-1.73-1.73H1.55zm1.92 3.46h6.06v6.06H3.47V3.47zm9.52 0h23.35v6.06H12.99V3.47zM3.47 13h6.06v14.7H3.47v-14.7zm9.52 0h23.35v14.7H12.99v-14.7z"/>
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

# frozen_string_literal: true

module Blacklight
  module Icons
    class TexasComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 29 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M26.32 14.13v-5.5h-4.75V6.3h1.67V2.5H16.3v3.8h1.74v2.31H11.3V6.31h1.74V2.5H6.1v3.8h1.67v2.31H3v5.5h3.55v-1.64h1.2v3.02c0 6.48 4.95 7.7 4.95 7.7v2.77h-1.4v3.52h6.72v-3.52h-1.4v-2.78s4.94-1.22 4.94-7.7v-3.02h1.2v1.65h3.55zm-13.61 5.23s-1.4-.82-1.4-2.34v-4.55h1.4v6.89zm5.32-2.34c0 1.52-1.4 2.34-1.4 2.34v-6.88h1.4v4.54z"/>
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

# frozen_string_literal: true

module Blacklight
  module Icons
    class BaruchCunyComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M28.66 22.76c-.97-7.44-9.68-8.5-9.68-8.5 6.18-3.64 6.72-6.9 6.72-7.7C25.85 1.04 20.73.4 20.73.4 19.38-.03 3.28.24 3.28.24c1.57.87 1.55 2.52 1.55 2.52.1.67.3 26.13.3 26.13-.3 2.48-1.8 2.96-1.8 2.96l17.42-.1c9.13-.42 7.92-8.99 7.92-8.99zm-11.44 7.4s-5.15.84-5.35-2-.05-14.85-.05-14.85l-.1-9.56c-.05-2.1 2.73-2.02 2.73-2.02 5.8 0 5.25 5.85 5.25 5.85 0 3.19-4.87 7.12-4.87 7.12.44.1 6.67 1.54 7.11 9.36 0 0 .7 5.45-4.73 6.1z"/>
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

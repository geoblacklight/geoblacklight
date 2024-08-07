# frozen_string_literal: true

module Blacklight
  module Icons
    class MultipolygonComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 32">
          	<title>#{title}</title>
          	<path fill="none" stroke="#6c757d" stroke-width="1.72" d="M.86 10.9h4.2v4.17H.86V10.9zM16.87 10.9h4.2v4.17h-4.2V10.9zM.86 26.89h4.2v4.22H.86v-4.22zM16.87 26.89h4.2v4.22h-4.2v-4.22z"/>
          	<path fill="none" stroke="#6c757d" stroke-width="3.44" d="M5.02 13.06H16.8M5.02 29.56H16.8M18.94 26.83V15.07M3.01 26.83V15.07"/>
          	<path fill="none" stroke="#6c757d" stroke-width="1.72" d="M8.75.86h4.2v4.16h-4.2V.86zM24.76.86h4.2v4.16h-4.2V.86zM8.75 16.84h4.2v4.23h-4.2v-4.23zM24.76 16.84h4.2v4.22h-4.2v-4.22z"/>
          	<path fill="none" stroke="#6c757d" stroke-width="3.44" d="M12.91 3.01h11.77M12.91 19.52h11.77M26.83 16.79V5.02M10.9 16.79V5.02"/>
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

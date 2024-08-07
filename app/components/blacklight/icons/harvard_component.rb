# frozen_string_literal: true

module Blacklight
  module Icons
    class HarvardComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M1.17 1.17h27.04v10.19c0 13.48-8.54 18.92-13.52 21.81-4.98-2.89-13.52-8.33-13.52-21.81V1.17zm6.34 2.86v2.81h.94v13.49H7.5v2.81h4.83v-2.81h-.93v-5.26h6.56v5.26h-.93v2.81h4.83v-2.81h-.94V6.84h.94V4.02h-4.83v2.82h.94v5.26H11.4V6.84h.93V4.02H7.51z"/>
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

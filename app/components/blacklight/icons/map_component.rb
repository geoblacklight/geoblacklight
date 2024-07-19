# frozen_string_literal: true

module Blacklight
  module Icons
    class MapComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M8 0c.27 0 .5.23.5.5v23a.5.5 0 0 1-.27.44l-7.5 4A.44.44 0 0 1 .5 28a.51.51 0 0 1-.5-.5v-23c0-.19.1-.36.27-.44l7.5-4A.44.44 0 0 1 8 0zm19.5 0c.27 0 .5.23.5.5v23a.5.5 0 0 1-.27.44l-7.5 4A.44.44 0 0 1 20 28a.51.51 0 0 1-.5-.5v-23c0-.19.1-.36.27-.44l7.5-4A.44.44 0 0 1 27.5 0zM10 0a.5.5 0 0 1 .22.05l8 4c.17.1.28.26.28.45v23a.5.5 0 0 1-.72.45l-8-4a.52.52 0 0 1-.28-.45V.5c0-.27.23-.5.5-.5z"/>
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

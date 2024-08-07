# frozen_string_literal: true

module Blacklight
  module Icons
    class MassgisComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M15 0l15 6v2h-2c0 .55-.48 1-1.08 1H3.08C2.48 9 2 8.55 2 8H0V6zM4 10h4v12h2V10h4v12h2V10h4v12h2V10h4v12h.92c.6 0 1.08.45 1.08 1v1H2v-1c0-.55.48-1 1.08-1H4V10zm24.92 15c.6 0 1.08.45 1.08 1v2H0v-2c0-.55.48-1 1.08-1h27.84z"/>
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

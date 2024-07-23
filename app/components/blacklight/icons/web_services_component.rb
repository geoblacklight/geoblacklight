# frozen_string_literal: true

module Blacklight
  module Icons
    class WebServicesComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M22 14.5v5a4.5 4.5 0 0 1-4.5 4.5h-13A4.5 4.5 0 0 1 0 19.5v-13A4.5 4.5 0 0 1 4.5 2h11c.28 0 .5.22.5.5v1a.5.5 0 0 1-.5.5h-11A2.5 2.5 0 0 0 2 6.5v13A2.5 2.5 0 0 0 4.5 22h13a2.5 2.5 0 0 0 2.5-2.5v-5c0-.28.22-.5.5-.5h1c.28 0 .5.22.5.5zM28 1v8a1 1 0 0 1-1 1 .99.99 0 0 1-.7-.3l-2.75-2.75-10.19 10.19c-.1.1-.23.16-.36.16s-.26-.07-.36-.16l-1.78-1.78c-.1-.1-.15-.23-.15-.36s.06-.27.15-.36L21.05 4.45 18.3 1.7A1 1 0 0 1 18 1a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1z"/>
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

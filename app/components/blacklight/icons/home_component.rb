# frozen_string_literal: true

module Blacklight
  module Icons
    class HomeComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 26 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M22 15.5V23a1 1 0 0 1-1 1h-6v-6h-4v6H5a1 1 0 0 1-1-1v-7.5l.02-.1L13 8l8.98 7.4a.2.2 0 0 1 .02.1zm3.48-1.08l-.96 1.16a.5.5 0 0 1-.33.17h-.05a.5.5 0 0 1-.33-.1L13 6.62 2.19 15.64a.53.53 0 0 1-.38.11.52.52 0 0 1-.33-.17l-.97-1.16a.51.51 0 0 1 .07-.7L11.8 4.36a1.92 1.92 0 0 1 2.38 0l3.8 3.19V4.5c0-.28.23-.5.5-.5h3c.29 0 .5.22.5.5v6.38l3.43 2.84c.2.17.23.5.06.7z"/>
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

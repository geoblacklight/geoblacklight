# frozen_string_literal: true

module Blacklight
  module Icons
    class BookmarkComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M18.19 2c.23 0 .47.05.69.14.68.27 1.12.9 1.12 1.61v20.14c0 .7-.44 1.34-1.12 1.61-.22.1-.46.13-.7.13a1.9 1.9 0 0 1-1.29-.5L10 18.5l-6.9 6.63c-.35.32-.8.51-1.29.51-.23 0-.47-.05-.69-.14A1.73 1.73 0 0 1 0 23.9V3.74c0-.7.44-1.34 1.12-1.6.22-.1.46-.15.7-.15h16.37z"/>
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

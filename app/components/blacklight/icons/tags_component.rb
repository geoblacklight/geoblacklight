# frozen_string_literal: true

module Blacklight
  module Icons
    class TagsComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M7 7a2 2 0 1 0-4 0 2 2 0 0 0 4 0zm16.67 9c0 .53-.22 1.05-.58 1.4l-7.67 7.7a2.01 2.01 0 0 1-2.83 0L1.42 13.9A5.43 5.43 0 0 1 0 10.5V4c0-1.1.9-2 2-2h6.5c1.1 0 2.62.62 3.42 1.42L23.1 14.58c.36.37.58.89.58 1.42zm6 0c0 .53-.22 1.05-.58 1.4l-7.67 7.7a2.1 2.1 0 0 1-1.42.57c-.81 0-1.22-.37-1.75-.92l7.34-7.34a2.01 2.01 0 0 0 0-2.83L14.42 3.42A5.5 5.5 0 0 0 11 2h3.5c1.1 0 2.63.62 3.42 1.42L29.1 14.58c.36.37.58.89.58 1.42z"/>
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

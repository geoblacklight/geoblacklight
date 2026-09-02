# frozen_string_literal: true

module Blacklight
  module Icons
    class GeoreferencedComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="currentColor" fill-rule="evenodd" d="M16 5a11 11 0 1 0 0 22 11 11 0 1 0 0-22zm0 3.5a7.5 7.5 0 1 1 0 15 7.5 7.5 0 1 1 0-15zm0 4a3.5 3.5 0 1 0 0 7 3.5 3.5 0 1 0 0-7zM0 14.25h4v3.5H0zm28 0h4v3.5h-4zM14.25 0h3.5v4h-3.5zm0 28h3.5v4h-3.5z"/>
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

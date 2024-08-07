# frozen_string_literal: true

module Blacklight
  module Icons
    class ImageComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M10 9a3 3 0 1 1-6 0 3 3 0 0 1 6 0zm16 6v7H4v-3l5-5 2.5 2.5 8-8zm1.5-11h-25c-.27 0-.5.23-.5.5v19c0 .27.23.5.5.5h25c.27 0 .5-.23.5-.5v-19c0-.27-.23-.5-.5-.5zm2.5.5v19a2.5 2.5 0 0 1-2.5 2.5h-25A2.5 2.5 0 0 1 0 23.5v-19A2.5 2.5 0 0 1 2.5 2h25A2.5 2.5 0 0 1 30 4.5z"/>
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

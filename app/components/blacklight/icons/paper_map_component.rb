# frozen_string_literal: true

module Blacklight
  module Icons
    class PaperMapComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M0 6l10-4v24L0 30V6zm22 0v24l-10-3.33v-24zm10-4v24l-8 3.2v-24z"/>
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

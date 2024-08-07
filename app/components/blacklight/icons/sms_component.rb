# frozen_string_literal: true

module Blacklight
  module Icons
    class SmsComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 28">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M7.25 22a1.25 1.25 0 0 0-2.5 0 1.25 1.25 0 0 0 2.5 0zm3.25-2.5v-11c0-.27-.23-.5-.5-.5H2c-.27 0-.5.23-.5.5v11c0 .27.23.5.5.5h8c.27 0 .5-.23.5-.5zm-3-13.25c0-.14-.1-.25-.25-.25h-2.5c-.14 0-.25.1-.25.25s.1.25.25.25h2.5c.14 0 .25-.1.25-.25zM12 6v16c0 1.1-.9 2-2 2H2c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2h8c1.1 0 2 .9 2 2z"/>
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

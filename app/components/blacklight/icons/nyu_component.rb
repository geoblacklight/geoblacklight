# frozen_string_literal: true

module Blacklight
  module Icons
    class NyuComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M8.3 7.23c-1.8 1.94-2.64 8.9 5.08 8.9h.2c-4.79-2.65-4.16-6.6-2.29-9.39.21-.35-1.18-3.61-1.25-3.13-.14 1.4-1.46 3.06-1.73 3.62z"/>
          	<path fill="#6c757d" d="M14.84 15.98c-3.13-5.9 3.4-9.86 3.4-10.56 0-2.01-1.32-5.9-1.46-5.35-.48 1.8-2.99 4.45-3.47 5-4.45 4.87-3.34 8.76 1.53 10.91z"/>
          	<path fill="#6c757d" d="M15.53 15.98c.42-5.97 6.19-6.67 6.67-7.85.77-2.01-.83-5.7-.97-5.42-.55 1.46-1.74 2.78-1.74 2.78-4.8 3.62-5.7 6.6-3.96 10.36v.14z"/>
          	<path fill="#6c757d" d="M16.09 16.12c9.31.77 8.82-9.93 8.82-9.93-.55 1.39-1.73 2.08-1.8 2.22-1.18 1.53-5.91 1.67-6.95 7.57-.07 0-.07.14-.07.14zM11.85 16.89h6.32v1.88h-6.32v-1.88zM14.49 31.7c.07.27.7.48.9 0l1.53-12.17h-3.75l1.32 12.16z"/>
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

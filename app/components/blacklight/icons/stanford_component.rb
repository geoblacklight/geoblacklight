# frozen_string_literal: true

module Blacklight
  module Icons
    class StanfordComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M5.77 5.01L10.2.6h11.7l4.32 4.42v6.25h-7.72V8.33h-4.68v4.23h8.47l3.93 3.8v11.5l-3.86 3.85H9.65l-3.88-3.9V21.6h8.34v2.57h4.75v-3.94H9.63l-3.86-3.86V5zm.5.23v10.93l3.56 3.56h9.53v4.97h-5.78v-2.57h-7.3v5.48l3.57 3.6h12.3l3.55-3.55V16.59l-3.64-3.5H13.3V7.85H19v2.91h6.7v-5.5l-4.03-4.13H10.4zm4.34-3.57h10.87l3.71 3.83v4.78h-5.66V7.36h-6.75v6.29h9.07l3.34 3.19v10.64l-3.25 3.26H10.06l-3.27-3.31v-4.75h6.28v2.57h6.8v-6h-9.83l-3.26-3.26V5.5z"/>
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

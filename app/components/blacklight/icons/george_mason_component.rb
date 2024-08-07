# frozen_string_literal: true

module Blacklight
  module Icons
    class GeorgeMasonComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
          <title>#{title}</title>
          	<path fill="#6c757d" d="M32.088 0.6l2.545-4.6c-0.605 0.567-0.9 0.745-1.47 1.13-3.077 2.112-6.864 2.615-10.668 5.744-2.58 2.124-3.773 5.202-3.773 5.202s3.464-3.9 8.703-5.832c2.113-0.783 3.587-1.213 4.663-1.632z"></path>
          <path fill="#6c757d" d="M30.73 3.072c-2.758 0.88-6.042 1.716-9.407 3.987-2.62 1.77-4.143 4.787-4.143 4.787s3.696-3.696 9.068-4.958l2.75-0.642 1.734-3.174zM27.66 8.796c-1.32 0.12-4.078 0.366-7.303 2.162-2.122 1.18-3.795 2.797-3.795 2.797l-0.005 0.010-0.003-0.002c-0.63 1.182-1.502 3.147-2.357 5.26l-4.253-7.763h-5.577l1.782 1.784v13.136l-1.782 1.78h6.1l-1.812-1.782v-10.2l3.983 7.13-1.257 4.135 1.283-1.5s1.040-4.955 5.142-9.82v10.393l-1.783 1.684h7.064l-1.536-1.784v-13.88c3.714-2.944 6.115-3.54 6.1-3.54z"></path>
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

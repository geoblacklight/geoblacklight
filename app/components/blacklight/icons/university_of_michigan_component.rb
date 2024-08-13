# frozen_string_literal: true

module Blacklight
  module Icons
    class UniversityOfMichiganComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <!-- Generated by IcoMoon.io -->
          <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="45" height="32" viewBox="0 0 45 32">
          <title>#{title}</title>
          	<path fill="#6c757d" d="M44.59 23v9h-16.79v-9h3.63v-9.1l-9.2 12.53-9.070-12.53v9.12h3.64v8.98h-16.8v-9h3.4v-14h-3.4v-9h13.2l9.1 12.65 9.090-12.65h13.2v9h-3.4v14z"></path>
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
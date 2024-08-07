# frozen_string_literal: true

module Blacklight
  module Icons
    class LewisClarkComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 23 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M12.38 31.94c3.65-1 7.5-3.88 9.48-8.45-1.4 2.41-4.1 4.14-7.8 2.3s-5.83-.4-6.48.22c.73 1.93 2.1 3.9 4.8 5.93zM6.83 21.95c.51-3.7 3.93-5.26 8.3-3.16 4.16 1.99 7.7-.67 8.12-2.3V0H6.77v18.75c.01 1.08 0 2.14.06 3.2z"/>
          	<path fill="#6c757d" d="M6.58 25.66c-.73-2.37-.63-4.67-.66-6.9V0H0v16.25C-.16 25.2 5.74 30.65 11.12 32c-2.58-2.13-3.9-4.24-4.54-6.34z"/>
          	<path fill="#6c757d" d="M14.43 21.58c-3.5-1.26-6.07-.8-7.51 1.55.1.86.26 1.64.49 2.38l-.02-.08.12.37c.7-2.15 2.73-4.39 7.12-2.74 2.6.96 7.12 1.28 8.2-2.61.23-.95.37-2.06.41-3.19v-.03c-1.06 4.5-5.1 5.68-8.81 4.35z"/>
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

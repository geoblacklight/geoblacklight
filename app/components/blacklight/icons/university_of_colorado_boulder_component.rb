# frozen_string_literal: true

module Blacklight
  module Icons
    class UniversityOfColoradoBoulderComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 59.6 57.6">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M47.4,57.6H24.4l-8.2-8.1v-6.1H8.1L0,35.3V8.1L8.1,0h27.2l8.1,8.1v6.1h16.2v15h-4v20.3L47.4,57.6z M24.9,56.3
          	h22l7.4-7.3V28h4V15.5H42.1V8.6l-7.3-7.3H8.6L1.3,8.6v26.1l7.4,7.3h8.8V49L24.9,56.3z M44,17.6V46H27.8v-6.1h6.1l6.1-6.1v-8.1h-8.1
          	v6h-4V17.6H15.6v8.1h4v6h-8.1V11.5h20.3v6.1H40V9.5l-6.1-6.1H9.5L3.4,9.5v24.3l6.1,6.1h10.1V48l6.2,6.1H46l6.2-6.1V25.8h4v-8.1
          	C56.1,17.6,44,17.6,44,17.6z"/>
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

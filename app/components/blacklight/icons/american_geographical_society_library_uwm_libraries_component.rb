# frozen_string_literal: true

module Blacklight
  module Icons
    class AmericanGeographicalSocietyLibraryUwmLibrariesComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <?xml version="1.0" encoding="utf-8"?>
          <!-- Generator: Adobe Illustrator 27.2.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)	-->
          <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
          	 viewBox="0 0 201 141.2" style="enable-background:new 0 0 201 141.2;" xml:space="preserve">
          <style type="text/css">
          	.st0{fill-rule:evenodd;clip-rule:evenodd;fill:#6c757d;}
          	.st1{fill-rule:evenodd;clip-rule:evenodd;stroke:#6c757d;stroke-width:0.1;fill:#6c757d;}
          	.st2{fill:#6c757d;}
          </style>
          <title>#{title}</title>
          	<path class="st0" d="M115.7,69.9h21.1l2.6-29.6c0.2-2.8,0.4-5.6,0.6-8.4h0.7c0.2,2.9,0.7,5.7,1.4,8.6l7.8,29.3h12.7l8.7-31
          	c0.6-2.2,1-4.6,1.4-6.9h0.4L176,70h21.1l-9.9-69.3H165l-6.8,27.2c-0.7,2.9-1.1,6.2-1.5,9.2h-0.6l-8.3-36.4h-22.5L115.7,69.9z"/>
          <path class="st1" d="M197.1,98.5c-5-1.7-11-2.7-17.5-2.7c-23.3,0-37.2,15.4-65.7,13.3c-1.8,0-3.3-1.5-3.3-3.3c0-0.3,0-0.6,0.1-0.9
          	l-1.1,7.5c-0.1,0.3-0.1,0.6-0.1,0.9c0,1.8,1.5,3.3,3.3,3.3c28.5,2.1,43.4-13.3,66.8-13.3c6.5,0,12.5,1,17.5,2.7v20.8
          	c-5-1.7-11-2.7-17.5-2.7c-23.3,0-39.3,15.2-67.8,13.1c-2.6,0-4.8-2.1-4.8-4.8c0-0.3,0-0.6,0.1-0.8l1.9-13.1L5,130.2v-21.1l106.5-7.7
          	l0.8-5.7L5,99.9V78.8h104c2.6,0,4.7,2.1,4.7,4.8l-0.1,0.8c-0.1,0.3-0.1,0.6-0.1,0.9c0,1.8,1.5,3.3,3.3,3.3
          	c28.5,2.1,39.4-13.1,62.8-13.1c6.5,0,12.5,1,17.5,2.7L197.1,98.5L197.1,98.5z"/>
          <path class="st2" d="M78.2,0.7C78.9,0.7,79,1,79,1.6v3.3c0,0.3-0.1,0.6-0.1,0.7c-0.1,0.1-2.2,0.2-2.4,0.2c-1.9,0.1-4,0.8-4,3.7
          	c0,1.6,0.3,2.8,1.6,8l8.3,34.8c5-19,10.9-44,13-51.3c0.3-0.3,0.4-0.3,0.7-0.3c1.9,0,2.7-0.2,2.9,0.4l15,54.8c0,0-1.4,9.8-1.9,13.2
          	c-0.1,0.8-0.4,0.8-1,0.8h-4.4c-0.6,0-0.7-0.2-0.9-0.9c-1.6-7.7-2.2-10.4-4.7-19.4c-2.6-9.5-5-20.5-6.8-28.8
          	c-2.4,10.3-2.9,12.6-8.3,33.5c-1.9,7.2-2.4,9.5-3.7,14.9c-0.2,0.6-0.3,0.7-0.9,0.7H76c-0.5,0-0.6-0.3-0.7-1
          	c-1.5-6.1-12.6-49.3-12.9-50.6C60.9,12.4,60,6.6,56.6,6.6c-2,0-2.4,2.7-2.4,6.4v28.1c-0.1,6.5-0.1,16.1-6.3,23.5
          	c-1.7,2.1-7.1,7.7-18,7.7C25,72.4,18.7,71,14,66.1c-5.9-6.2-6.2-13.9-6.3-20.9V14.6c0-7-0.7-9-6.2-9C1.1,5.6,1.1,5.5,1,4.9V1.6
          	c0-0.7,0-1.1,0.8-1.1c1.8,0,19.2,0.1,23.5,0c0.2,0,0.5,0.1,0.5,0.7v3.7c-0.1,0.7-0.2,0.7-1.1,0.7c-6.1,0-5.8,2.5-5.8,9.7v22.1
          	l0.1,7.9c0.2,4,0.5,7.7,2.2,11.7c1.2,2.7,4.9,8.4,12.2,8.4c4,0,7.9-1.7,10.8-5.1c4.3-5.1,4.9-12,5-19.5V14.3c0-6.9-0.6-8.6-7.5-9
          	c-0.5,0-0.6-0.1-0.6-0.6V1.4c0-0.6,0-0.7,0.5-0.7C41.8,0.7,77.2,0.7,78.2,0.7z"/>
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

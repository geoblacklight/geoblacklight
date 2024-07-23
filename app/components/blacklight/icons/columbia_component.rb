# frozen_string_literal: true

module Blacklight
  module Icons
    class ColumbiaComponent < Blacklight::Icons::IconComponent
      self.svg = svg

      def svg
        <<~SVG
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
          	<title>#{title}</title>
          	<path fill="#6c757d" d="M31.89 15.45a4.2 4.2 0 0 0-3.88-3.5c-3.48-.28-6.48 1.58-9.86 2.17-.27.05-.63-.52-.96-.85 1.57-1.18 1.35-3.5-.46-4.5a4.05 4.05 0 0 1 0-1.53c.14-.12 1.3.1 1.46-.04.17-.14.13-1.53.03-1.66s-1.41 0-1.48-.08c-.08-.1.03-1.34-.1-1.44-.08-.07-.44-.08-.64-.08s-.56 0-.65.08c-.12.1-.02 1.34-.09 1.44-.07.08-1.37-.06-1.48.08-.1.13-.14 1.52.03 1.66.16.14 1.32-.08 1.46.04.08.06.12 1.4 0 1.54-1.82 1-2.03 3.31-.46 4.49-.33.33-.7.9-.97.86-3.37-.6-6.37-2.46-9.85-2.18a4.2 4.2 0 0 0-3.88 3.5c-.61 3.54 1.94 6.27 3.17 9.28.4.95.74 2.23.68 3.33H28.04c-.06-1.1.28-2.38.67-3.33 1.24-3.01 3.79-5.74 3.18-9.28zM14.56 23.3c-.31 1.78-1.3 2.91-2.13 2.92-.54 0-.97-.2-1.36-.55-.54-.47-.99-1.26-.84-1.72.12-.15 1.58.07 1.68-.07.1-.15-.18-1.29-.34-1.43-.17-.15-1.49.05-1.66-.1-.18-.14-.34-1.55-.52-1.64 0 0-1.4-.2-1.5 0-.1.2.47 1.37.37 1.57s-1.94-.18-1.97.03c-.04.21.1 1.24.28 1.4.18.15 1.9.16 1.9.16.36.27.45.83.46 1.4 0 .72-.56 1.1-1.46.84-1.67-.47-3.73-4.08-4.96-6.59-.9-1.84-1.45-4.86.92-5.76 1.44-.55 2.96-.24 4.51.22 1.63.49 3.77 1.14 5.04 1.93.3.19-.37.04.75 2.52.53 1.16 1.05 3.63.83 4.87zm9.97 2.81c-.9.25-1.46-.12-1.46-.84 0-.57.1-1.13.46-1.4 0 0 1.72 0 1.9-.16s.31-1.2.28-1.4c-.03-.2-1.88.17-1.98-.03s.48-1.38.38-1.58c-.1-.2-1.5.01-1.5.01-.18.09-.34 1.5-.52 1.64s-1.5-.05-1.66.1c-.16.14-.44 1.28-.34 1.43.1.14 1.56-.08 1.68.07.14.46-.3 1.25-.84 1.72-.4.34-.83.55-1.37.55-.82-.01-1.8-1.14-2.12-2.92-.22-1.24.3-3.71.82-4.87 1.13-2.48.45-2.33.76-2.52 1.26-.79 3.4-1.44 5.04-1.93 1.55-.46 3.06-.77 4.5-.22 2.37.9 1.83 3.92.93 5.76-1.23 2.5-3.3 6.12-4.96 6.6z"/>
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

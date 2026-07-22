module Geoblacklight
  module Document
    class PreviewComponent < ViewComponent::Base
      def initialize(document:)
        @document = document
        super()
      end

      def render?
        @document.previewable?
      end
    end
  end
end

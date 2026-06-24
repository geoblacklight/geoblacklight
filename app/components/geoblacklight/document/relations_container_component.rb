module Geoblacklight
  module Document
    class RelationsContainerComponent < ViewComponent::Base
      def initialize(document:)
        super()
        @document = document
      end

      attr_reader :document
    end
  end
end

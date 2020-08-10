# frozen_string_literal: true
module Geoblacklight
  module Metadata
    class Iso19139 < Base
      private

      ##
      # Retrieve the Class for the GeoCombine data model
      # @return [GeoCombine::Iso19139]
      def metadata_class
        GeoCombine::Iso19139
      end
    end
  end
end

# frozen_string_literal: true
module Geoblacklight
  module Metadata
    class Fgdc < Base
      private

      ##
      # Retrieve the Class for the GeoCombine data model
      # @return [GeoCombine::Fgdc]
      def metadata_class
        GeoCombine::Fgdc
      end
    end
  end
end

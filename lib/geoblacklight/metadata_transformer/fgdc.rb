module Geoblacklight
  module MetadataTransformer
    ##
    # Class for transforming FGDC XML Documents
    class Fgdc < Base
      private

      ##
      # Retrieve the Class for the GeoCombine::Metadata instance
      # @return [GeoCombine::Fgdc]
      def metadata_class
        GeoCombine::Fgdc
      end
    end
  end
end

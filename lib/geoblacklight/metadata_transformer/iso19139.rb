module Geoblacklight
  module MetadataTransformer
    ##
    # Class for transforming ISO19139 XML Documents
    class Iso19139 < Base
      private

      ##
      # Retrieve the Class for the GeoCombine::Metadata instance
      # @return [GeoCombine::Iso19139]
      def metadata_class
        GeoCombine::Iso19139
      end
    end
  end
end

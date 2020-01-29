module Geoblacklight
  # Determines whether references or dct_references_s is used
  class NestedReferences
    attr_reader :document

    def initialize(document)
      @document = document
    end
    
    def references
      @references = document.fetch('references', []).map { |r| NestedReference.new(r) }
    end

    def downloads
      references.select { |d| d.type == 'http://schema.org/downloadUrl' }
    end
    
    class NestedReference
      attr_reader :reference

      def initialize(reference)
        @reference = reference
      end

      def type
        parsed.select { |p| p[0] == 'type' }&.first&.dig(1)
      end

      def url
        parsed.select { |p| p[0] == 'url' }&.first&.dig(1)
      end

      def label
        parsed.select { |p| p[0] == 'label' }&.first&.dig(1)
      end


      private

      ##
      # We have to do some fun parsing here since the docs returned aren't JSON
      def parsed
        reference.sub(/^{/, '').sub(/}$/, '').split(',').map do |s|
          s.strip.split('=', 2)
        end
      end
    end
  end
end

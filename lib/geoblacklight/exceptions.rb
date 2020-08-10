# frozen_string_literal: true
module Geoblacklight
  module Exceptions
    class ExternalDownloadFailed < StandardError
      def initialize(options = {})
        @options = options
      end

      ##
      # URL tried from failed download
      # @return [String]
      def url
        @options[:url].to_s
      end

      ##
      # Message passed from a failed download
      # @return [String]
      def message
        @options[:message].to_s
      end
    end
    class WrongDownloadFormat < StandardError
    end
    class WrongBoundingBoxFormat < StandardError
    end
  end
end

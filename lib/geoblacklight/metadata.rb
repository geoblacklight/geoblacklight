module Geoblacklight
  class Metadata
    ##
    # Instantiates a Geoblacklight::Metadata object used for retrieving and
    # formatting metadata
    # @param reference [Geoblacklight::Reference] the reference object
    def initialize(reference)
      @reference = reference
    end

    ##
    # Handles metadata and returns the retrieved metadata or an error message if
    # something went wrong
    # @return [String] returned metadata string
    def metadata
      response = retrieve_metadata
      if response.nil? || response.status == 404
        Geoblacklight.logger.error "Could not reach #{@reference.endpoint}"
        return "Could not reach #{@reference.endpoint}"
      else
        return response.body
      end
    end

    ##
    # Retrieves metadata from a url source
    # @return [Faraday::Response, nil] Faraday::Response or nil if there is a
    # connection error
    def retrieve_metadata
      conn = Faraday.new(url: @reference.endpoint)
      conn.get
    rescue Faraday::Error::ConnectionFailed => error
      Geoblacklight.logger.error error.inspect
      nil
    rescue Faraday::Error::TimeoutError => error
      Geoblacklight.logger.error error.inspect
      nil
    end
  end
end

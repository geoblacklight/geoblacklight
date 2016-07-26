module Geoblacklight
  ##
  # Adds helper behavior logic for GeoBlacklight, to used alongside
  # BlacklightHelperBehavior
  module GeoblacklightHelperBehavior
    ##
    # Calls the presenter on the requested method
    # @param [Symbol, String] presenting_method
    # @return [String]
    def geoblacklight_present(presenting_method, document = @document)
      presenter(document).try(presenting_method.to_sym) || ''
    end
  end
end

# frozen_string_literal: true

##
# Adds helper behavior logic for GeoBlacklight, to used alongside
# BlacklightHelperBehavior
module Geoblacklight
  module GeoblacklightHelperBehavior
    include Blacklight::DocumentHelperBehavior

    ##
    # Calls the presenter on the requested method
    # @param [Symbol, String] presenting_method
    # @return [String]
    def geoblacklight_present(presenting_method, document = @document)
      document_presenter(document).try(presenting_method.to_sym) || ""
    end
  end
end

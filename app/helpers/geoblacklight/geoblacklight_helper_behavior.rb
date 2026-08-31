# frozen_string_literal: true

##
# Adds helper behavior logic for GeoBlacklight, to used alongside
# BlacklightHelperBehavior
#
# @deprecated This module is removed in GeoBlacklight 5. Search result
#   presentation moved to Geoblacklight::SearchResultComponent.
module Geoblacklight
  module GeoblacklightHelperBehavior
    include Blacklight::BlacklightHelperBehavior

    ##
    # Calls the presenter on the requested method
    # @param [Symbol, String] presenting_method
    # @return [String]
    # @deprecated
    def geoblacklight_present(presenting_method, document = @document)
      Geoblacklight.deprecation.silence { document_presenter(document).try(presenting_method.to_sym) } || ""
    end
    Geoblacklight.deprecation.deprecate_methods(Geoblacklight::GeoblacklightHelperBehavior,
      geoblacklight_present: "use Geoblacklight::SearchResultComponent instead")
  end
end
